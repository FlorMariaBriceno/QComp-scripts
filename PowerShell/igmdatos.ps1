
function Carpeta {
    Add-Type -AssemblyName Microsoft.VisualBasic; #llamamos a las librerias necesarias para usar interfaz de usuario
    Add-Type -AssemblyName PresentationCore, PresentationFramework
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $null = $browser.ShowDialog()
    $path = $browser.SelectedPath
    if ($path -ne ""){
        return $path
    }
    else {
        [System.Windows.MessageBox]::Show("No se eligió ninguna carpeta",'Error','OK',16)
        Exit
    }
}
function Archivo{
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $path
    $OpenFileDialog.filter = "All files (*.*)|*.*|IGMPLOT log files (*.log)|*.log"
    $OpenFileDialog.ShowDialog() |  Out-Null
    $file=$OpenFileDialog.filename
    if ($OpenFile -ne "") 
        {Write-Output "Archivo: $file" } 
    else 
        {[System.Windows.MessageBox]::Show("No se eligió ningún archivo",'Error','OK',16)
        Exit}
    
    return $file
}
$path=Carpeta
Set-Location $path
for ($i=1; $i -le 12; $i++){
    $igm=[string]$i
    (Write-Output "DATOS dg INTER $igm" &&
        Select-String -Raw -Pattern "of the dg peak" -Path $pwd\$igm.log &&
        Select-String -Pattern "(.+)sum(.+)dg(.+)Inter" -Raw  -Path $pwd\$igm.log) | Out-File $igm-igm.txt
        <#$igmty=(Select-String -Pattern "\d[a-b]" $pwd\$igm.log).Matches.Value | Select-Object filename,matches
        $igmval=(Select-String "\d\D\d{4}\D\D\d\d" $pwd\$igm.log).Matches.Value #>
       
}
Get-Content $pwd\*-igm.txt | Set-Content todo-igms.txt
Remove-Item $pwd\*-igm.txt
$msgboxinput =[System.Windows.MessageBox]::Show("¿Abrir archivo de salida?",'Aviso',4,64)
switch ($msgboxinput) {
    'No' {Exit}
    'Yes' {C:\Windows\notepad.exe $pwd\todo-igms.txt}
}