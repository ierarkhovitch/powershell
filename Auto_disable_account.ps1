Import-Module activedirectory
$SmtpServer = "" ###
$firedOU = "" ### 
########################Поиск заблокированных учёток##############################################

$date = Get-Date -Format 'dd-MM-yyyy'
$date_lt = (Get-Date).AddDays("4")
$date_exp = (Get-Date).AddDays("-4")
$base = "" ### Search Base
$encoding = [System.Text.Encoding]::UTF8
$expusers = Get-ADUser -Filter {AccountExpirationDate -lt $date_exp} -SearchBase $base -Properties * | select samaccountname,mail,AccountExpirationDate | Sort-Object samaccountname

######################################Ищем учётки котрые истекут в течении 4 дней###################

$users = Get-ADUser -Filter {(AccountExpirationDate -ne "null" -and AccountExpirationDate -gt $date -and AccountExpirationDate -lt $date_lt)} -SearchBase $base -Properties * | select samaccountname,mail,AccountExpirationDate | Sort-Object AccountExpirationDate
$import = $users | ConvertTo-Html | Out-String
$import_exp = $expusers | ConvertTo-Html | Out-String

###################################Отправляем письмо################################################

if($users.Count -ne "0" -and $expusers.count -ne "0")
{
#Если таковы юзеры есть отправляем на почту список сотрудников
Send-MailMessage -From  'PS_Bot <ps_bot@test.ru>' -to <# email #> -SmtpServer $SmtpServer -Subject 'Уведомление о блокировании учётных записей в AD' -Body "Список учётных записей у которых срок действия меньше 5 дней `n$import Список учётных записей перемещенных в 'Уволенные сотрудники' сегодня `n$import_exp" -BodyAsHtml -Encoding $encoding
}
elseif($users.Count -eq "0" -and $expusers.count -ne "0")
{
#Если таковы юзеры есть отправляем на почту список сотрудников
Send-MailMessage -From  'PS_Bot <ps_bot@test.ru>' -to <# email #> -SmtpServer $SmtpServer -Subject 'Уведомление о блокировании учётных записей в AD' -Body "Список учётных записей перемещенных в 'Уволенные сотрудники' сегодня `n$import_exp" -BodyAsHtml -Encoding $encoding
}
else 
{
#Если таковы юзеры есть отправляем на почту список сотрудников
Send-MailMessage -From  'PS_Bot <ps_bot@test.ru>' -to <# email #> -SmtpServer $SmtpServer -Subject 'Уведомление о блокировании учётных записей в AD' -Body "Список учётных записей у которых срок действия меньше 5 дней `n$import" -BodyAsHtml -Encoding $encoding
}

###########удаление групп и перемещение в заданный контейнер заблокированных уз больше 4 дней########

$LogPath = 'D:\Disable_users\log\'
$Logfile = $LogPath + $date + ".txt"
#Get-ADUser -Filter {Enabled -eq "false" -and AccountExpirationDate -lt $date_exp} -SearchBase $base -Properties * | select samaccountname,mail,@{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}},@{n='lastLogonTimeStamp';e={[DateTime]::FromFileTime($_.lastLogonTimeStamp)}} ,AccountExpirationDate,whenChanged | Sort-Object lastLogonTimestamp | Export-Csv -Path $path -Delimiter ";" -NoTypeInformation -Encoding UTF8 #указываем необходимый контейнер

############################Функия блокировки учётной записи#########################################

function DismissExpiredUsers()
{	
    $expusers = Get-ADUser -Filter {AccountExpirationDate -lt $date_exp} -SearchBase $base -Properties * 
	#if($expusers -eq $null) {return;}
	foreach($usr in $expusers)
	{
		Add-LogMessage ("Start processing " + $usr.SamAccountName)
        Disable-ADAccount $usr				
        Remove-UserFromGroups $usr
        MoveUserToFiredOU $usr
		Add-LogMessage ("Account " + $usr.DisplayName + " disabled!")
		Add-LogMessage "NEW_LINE"
	}	
}

##############################Функция логирования#####################################################

function Add-LogMessage($message)
{
	if($message -eq "NEW_LINE")
	{
		"`n`r" | Out-File $logfile -Encoding UTF8 -Append;
		return;
	}
	
	if ($message -eq $null)
	{
		return;
	}
	
	$logmessage = "[" + (Get-Date) + "] " + $message;
	$logmessage | Out-File $logfile -Encoding UTF8 -Append;	
}

##############################Функция удаления групп##################################################

function Remove-UserFromGroups($user_exp)
{
    Set-ADUser $user_exp -Clear telephoneNumber
	Add-LogMessage ("Removing user " + $user_exp.SamAccountName + " from groups:");	
	foreach ($gr in $user_exp.MemberOf)
	{
        try
            {
			    Remove-ADGroupMember $gr $user_exp.SamAccountName -Confirm:$false;
			    Add-LogMessage ($gr);
            }
        catch
            {
                Add-LogMessage ("Error. Group not remove " +$gr);
            }
	}
}

##############################Функция переноса в ou####################################################

function MoveUserToFiredOU($user_exp)
{
	$ou = $user_exp.DistinguishedName.Substring(4 + $user_exp.Name.Length)
	if ($ou -eq $firedOU)
	{
		Add-LogMessage "User already in propriate OU!"
		return;
	}
	try
	{
		Move-ADObject $user_exp -TargetPath "OU=Inactive Users and Groups,DC=PARFUM3,DC=local"
		Add-LogMessage ("User " + $user_exp.SamAccountName + " has been moved to Inactive Users")
	}
	catch
	{
		Add-LogMessage ("Error. User " + $user_exp.SamAccountName + " not moved to Inactive Users")
	}
}

DismissExpiredUsers