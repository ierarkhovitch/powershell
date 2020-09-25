Add-Type -assembly System.Windows.Forms
Import-Module activedirectory
$Date = Get-Date -Format "dd MMMM yyyy HH:mm:ss"
$User = $TextBox.Text
$servers_TC =  "TC18"
$servers_S3 = "T03"
$servers_WHS = "whs-dsk-05"
#################################GUI#################################

$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='GUI'
$main_form.Width = 900
$main_form.Height = 440

#################################Label#################################

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Описание работы кнопок"
$Label.Location  = New-Object System.Drawing.Point(10,10)
$Label.AutoSize = $true
$main_form.Controls.Add($Label)

$LogLabel = New-Object System.Windows.Forms.Label
$LogLabel.Text = "Логин пользователя"
$LogLabel.Location  = New-Object System.Drawing.Point(10,315)
$LogLabel.AutoSize = $true
$main_form.Controls.Add($LogLabel)

$ButLabel = New-Object System.Windows.Forms.Label
$ButLabel.Text = "Запуск скрипта"
$ButLabel.Location  = New-Object System.Drawing.Point(180,315)
$ButLabel.AutoSize = $true
$main_form.Controls.Add($ButLabel)

$СonclusionLabel = New-Object System.Windows.Forms.Label
$СonclusionLabel.Text = "Вывод"
$СonclusionLabel.Location  = New-Object System.Drawing.Point(450,10)
$СonclusionLabel.AutoSize = $true
$main_form.Controls.Add($СonclusionLabel)

#################################Инструкции#################################

$TabControl = New-Object System.Windows.Forms.TabControl
$TabPage1 = New-Object System.Windows.Forms.TabPage
$TabPage1.Text = 'S3-TS'
$TabLabel1 = New-Object System.Windows.Forms.Label
$TabLabel1.Text = "S3-TS
Удаление КЭШ 1С с серверов:
T03.
+Кэш из профиля

TC:
Удаление КЭШ 1С на TC..(Для УПП):
TC18.
+Кэш из профиля

WHS:
Удаление КЭШ 1С на новых серверах:
Desktop: whs-dsk-05.

+Кэш из профиля"
$TabLabel1.Location  = New-Object System.Drawing.Point(10,10)
$TabLabel1.AutoSize = $true
$TabPage1.Controls.Add($TabLabel1)

$TabPage2 = New-Object System.Windows.Forms.TabPage
$TabPage2.Text = 'Logon'
$TabLabel2 = New-Object System.Windows.Forms.Label
$TabLabel2.Text = "Вывод 10 последних хостов и времени подключения 
на которые заходил пользователь"
$TabLabel2.Location  = New-Object System.Drawing.Point(10,10)
$TabLabel2.AutoSize = $true
$TabPage2.Controls.Add($TabLabel2)

$TabPage3 = New-Object System.Windows.Forms.TabPage
$TabPage3.Text = 'Password'
$TabLabel3 = New-Object System.Windows.Forms.Label
$TabLabel3.Text = "Сброс пароля на стандартный
Qazwsx1234
С требованием смены пароля при входе
____________________________________
Необходимо поставить галучку CheckBox для смены 
пароля"
$TabLabel3.Location  = New-Object System.Drawing.Point(10,10)
$TabLabel3.AutoSize = $true
$TabPage3.Controls.Add($TabLabel3)


$TabPage4 = New-Object System.Windows.Forms.TabPage
$TabPage4.Text = 'GetGroups'
$TabLabel4 = New-Object System.Windows.Forms.Label
$TabLabel4.Text = "Выводит cписок групп у пользователя"
$TabLabel4.Location  = New-Object System.Drawing.Point(10,10)
$TabLabel4.AutoSize = $true
$TabPage4.Controls.Add($TabLabel4)

$TabPage5 = New-Object System.Windows.Forms.TabPage
$TabPage5.Text = 'Unlocks'
$TabLabel5 = New-Object System.Windows.Forms.Label
$TabLabel5.Text = "Снимает блокировку учётки"
$TabLabel5.Location  = New-Object System.Drawing.Point(10,10)
$TabLabel5.AutoSize = $true
$TabPage5.Controls.Add($TabLabel5)

$TabPage6 = New-Object System.Windows.Forms.TabPage
$TabPage6.Text = 'Search'
$TabLabel6 = New-Object System.Windows.Forms.Label
$TabLabel6.Text = "Поиск учётной записи в Active Directory"
$TabLabel6.Location  = New-Object System.Drawing.Point(10,10)
$TabLabel6.AutoSize = $true
$TabPage6.Controls.Add($TabLabel6)

$TabControl.Controls.Add($TabPage1)
$TabControl.Controls.Add($TabPage2)
$TabControl.Controls.Add($TabPage3)
$TabControl.Controls.Add($TabPage4)
$TabControl.Controls.Add($TabPage5)
$TabControl.Controls.Add($TabPage6)
$TabControl.Location  = New-Object System.Drawing.Point(10,30)
$TabControl.Width = 305
$TabControl.Height = 280
$main_form.Controls.add($TabControl)

#################################Поле ввода логина#################################

$TextBox = New-Object System.Windows.Forms.TextBox
$TextBox.Location  = New-Object System.Drawing.Point(12,335)
$TextBox.Text = ''
$main_form.Controls.Add($TextBox)

#################################Поле вывода#################################

$ListBox = New-Object System.Windows.Forms.RichTextBox
$ListBox.Location = New-Object System.Drawing.Point(450,30)
$ListBox.MinimumSize = New-object System.Drawing.Size(400, 350)
$ListBox.Autosize     = 1
$ListBox.Multiline = 1
$ListBox.ScrollBars = "Vertical"
$ListBox.BackColor = "White"
$ListBox.Font = "Arial MS,10"
$ListBox.ReadOnly = 1
$main_form.Controls.add($ListBox)

#################################Кнопки#################################

$button1 = New-Object System.Windows.Forms.Button
$button1.Text = 'S3-TS'
$button1.Location = New-Object System.Drawing.Point(150,333)
$button1.Add_Click({
    $User = $TextBox.Text
    foreach($serv in $servers_S3)
    {
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Local\1C\1cv8 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Roaming\1C\1CEStart -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Roaming\1C\1cv8 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Roaming\1C\1Cv81 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Roaming\1C\1Cv82 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    }
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V2\AppData\Roaming\1C\1CEStart -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V2\AppData\Roaming\1C\1cv8 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V2\AppData\Roaming\1C\1Cv81 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V2\AppData\Roaming\1C\1Cv82 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V6\AppData\Roaming\1C\1CEStart -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V6\AppData\Roaming\1C\1cv8 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V6\AppData\Roaming\1C\1Cv81 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V6\AppData\Roaming\1C\1Cv82 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    ###########################################################################
    $ListBox.AppendText('Кэш с S3-TS для '+$user+' удалён '+$Date+"`n")
    $ListBox.AppendText('#################################'+"`n")
    $ListBox.Focus();
})
$main_form.Controls.Add($button1)

$button2 = New-Object System.Windows.Forms.Button
$button2.Text = 'TC'
$button2.Location = New-Object System.Drawing.Point(230,333)
$button2.Add_Click({
    $User = $TextBox.Text
    foreach($serv in $servers_TC)
    {
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Local\1C\1cv8 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Roaming\1C\1CEStart -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Roaming\1C\1cv8 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Roaming\1C\1Cv81 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Roaming\1C\1Cv82 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    }
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V2\AppData\Roaming\1C\1CEStart -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V2\AppData\Roaming\1C\1cv8 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V2\AppData\Roaming\1C\1Cv81 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V2\AppData\Roaming\1C\1Cv82 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V6\AppData\Roaming\1C\1CEStart -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V6\AppData\Roaming\1C\1cv8 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V6\AppData\Roaming\1C\1Cv81 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V6\AppData\Roaming\1C\1Cv82 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    $ListBox.AppendText('Кэш c TC... для '+$user +' удалён '+$Date+"`n")
    $ListBox.AppendText('#################################'+"`n")
    $ListBox.Focus();
})
$main_form.Controls.Add($button2)

$button3 = New-Object System.Windows.Forms.Button
$button3.Text = 'Password'
$button3.Location = New-Object System.Drawing.Point(150,363)
$button3.Width = 155
$button3.Add_Click({
    if ($CheckBox.Checked -eq $True)
        {
        $User = $TextBox.Text
        Set-ADAccountPassword $User -Reset -NewPassword (ConvertTo-SecureString -AsPlainText -String 'Qazwsx1234' -force)
        Set-ADUser $User -ChangePasswordAtLogon $True #смена пароля при входе
        $ListBox.AppendText('Пароль для '+$User+' изменён на стандартный'+"`n")
        $ListBox.AppendText('Будет запрошена смена пароля при входе'+"`n")
        $ListBox.AppendText('#################################'+"`n")
        }
    else
        {
        $ListBox.AppendText('Для уверенности изменения пароля необходимо поставить "CheckBox"'+"`n")
        $ListBox.AppendText('#################################'+"`n")
        }
$ListBox.Focus();
})
$main_form.Controls.Add($button3)

$button4 = New-Object System.Windows.Forms.Button
$button4.Text = 'GetGroups'
$button4.Location = New-Object System.Drawing.Point(350,30)
$button4.Add_Click({
    $User = $TextBox.Text
    $Users = Get-ADUser $User
        foreach ($usr in $users)
            { 
            $grotput=Get-ADPrincipalGroupMembership $User|select SamAccountName|Sort-Object SamAccountName
            } 
    $Groups = $grotput.SamAccountName|Out-String
    $ListBox.AppendText($Groups)
    $ListBox.AppendText('#################################'+"`n")
    $ListBox.Focus();
})
$main_form.Controls.Add($button4)

$button5 = New-Object System.Windows.Forms.Button
$button5.Text = 'Unlocks'
$button5.Add_Click({
    $User = $TextBox.Text
    Unlock-ADAccount $User
    $ListBox.AppendText('Учётная запись '+$User+' разблокирована'+"`n")
    $ListBox.AppendText('#################################'+"`n")
    $ListBox.Focus();
})
$button5.Location = New-Object System.Drawing.Point(350,60)
$main_form.Controls.Add($button5)

$button6 = New-Object System.Windows.Forms.Button
$button6.Text = 'Search'
$button6.Location = New-Object System.Drawing.Point(350,90)
$button6.Add_Click({
    $User = $TextBox.Text+"*"
    $Searches = Get-ADUser -Filter {SamAccountName -like $User} -SearchBase "DC=PARFUM3,DC=local" -properties *
    $Managers = (Get-ADUser -Filter {distinguishedName -eq $Searches.manager} -SearchBase "DC=PARFUM3,DC=local" -properties *)
    $Manager = $Managers.SamAccountName
    $Manager_number = $Managers.telephoneNumber
    if ($Searches.Count -gt 1){
        foreach($Search in $Searches){$ListBox.AppendText($Search.SamAccountName+" ...... "+$Search.displayName+"`n")}
        $ListBox.AppendText('#################################'+"`n")
        }
    elseif ($Searches.Count -eq 0){
        $ListBox.AppendText('Пользователь не найден'+"`n")
        $ListBox.AppendText('#################################'+"`n")
    }
    else{
        $ListBox.AppendText('Пользователь '+$Searches.SamAccountName+' найден'+"`n"+'('+$Searches.title+' - '+$Searches.physicalDeliveryOfficeName+')'+"`n"+'Руководитель:'+"`n"+$Manager+' телефон - '+$Manager_number+"`n")
        $ListBox.AppendText('#################################'+"`n")
        }
    $ListBox.Focus();
})
$main_form.Controls.Add($button6)

$button7 = New-Object System.Windows.Forms.Button
$button7.Text = 'WHS'
$button7.Location = New-Object System.Drawing.Point(310,333)
$button7.Add_Click({
    $User = $TextBox.Text
    foreach($serv in $servers_WHS)
    {
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Local\1C\1cv8 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Roaming\1C\1CEStart -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Roaming\1C\1cv8 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Roaming\1C\1Cv81 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\$serv\c$\Users\$user\AppData\Roaming\1C\1Cv82 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    }
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V2\AppData\Roaming\1C\1CEStart -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V2\AppData\Roaming\1C\1cv8 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V2\AppData\Roaming\1C\1Cv81 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V2\AppData\Roaming\1C\1Cv82 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V6\AppData\Roaming\1C\1CEStart -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V6\AppData\Roaming\1C\1cv8 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V6\AppData\Roaming\1C\1Cv81 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    Remove-Item -Path \\parfum3\common\WHS_Profiles\$user.V6\AppData\Roaming\1C\1Cv82 -Exclude *.pfl,*.cfg,*.v8i,*.v8l,*.lst -Force -Recurse
    $ListBox.AppendText('Кэш whs для '+$user+' удалён '+$Date+"`n")
    $ListBox.AppendText('#################################'+"`n")
    $ListBox.Focus();
})
$main_form.Controls.Add($button7)

$button8 = New-Object System.Windows.Forms.Button
$button8.Text = 'Logon'
$button8.Location = New-Object System.Drawing.Point(310,363)
$button8.Add_Click({
    $User = $TextBox.Text
    $Contents = Get-Content -Path \\fs-01\Logon\$user\log.txt -last 20
    ForEach($Content in $Contents){$ListBox.AppendText($Content+"`n")}
    $ListBox.AppendText('#################################'+"`n")
    $ListBox.Focus();
})
$main_form.Controls.Add($button8)

$button9 = New-Object System.Windows.Forms.Button
$button9.Text = 'ClearText'
$button9.Location = New-Object System.Drawing.Point(775,5)
$button9.Add_Click({
    $ListBox.Clear()
})
$main_form.Controls.Add($button9)

#################################CheckBox#################################

$CheckBox = New-Object System.Windows.Forms.CheckBox
$CheckBox.Text = 'CheckBox'
$CheckBox.AutoSize = $true
$CheckBox.Checked = $false
$CheckBox.Location  = New-Object System.Drawing.Point(12,363)
$main_form.Controls.Add($CheckBox)

#################################ShowDialog#################################

$main_form.ShowDialog()