<# programa para buscar los valores de 
E2, Matriz de Fock y Energy gap 
NBO COMPATIBLE SOLO CON POWERSHELL 7 EN ADELANTE#>
#$nbo_1 = Read-Host -Prompt 'Número NBO del orbital n'
function Carpeta  {
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
function Archivo  {
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $path
    $OpenFileDialog.filter = "All files (*.*)|*.*|ORCA output files (*.out)|*.out|Text files (*.txt)|*.txt"
    $OpenFileDialog.ShowDialog() |  Out-Null
    $file=$OpenFileDialog.filename
    if ($file -ne "") 
        {Return $file} 
    else 
    {[System.Windows.MessageBox]::Show("No se eligió ningún archivo",'Error','OK',16)
    Exit}
}
$path=Carpeta
$file=Archivo

<#function Datos_nbo ($nbo_1,$nbo_2,$nbo_3,$nbo_4,$nbo_5){
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
# definir tamaño y lugar para la ventana 
$form = New-Object “System.Windows.Forms.Form”;
$form.Width = 400;
$form.Height = 150;
$form.Text = $title;
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;
#definir etiquetas
#1
$l1=New-Object "System.Windows.Forms.Label"
$l1.left = 25
$l1.top = 15
$l1.text=$nbo_1
#2
$l2=New-Object "System.Windows.Forms.Label"
$l2.left = 25
$l2.top = 25
$l2.text=$nbo_2 #>

$nbo_1 = [Microsoft.VisualBasic.Interaction]::InputBox('Número NBO del par libre','Orbital n','')
$nbo_2 = [Microsoft.VisualBasic.Interaction]::InputBox('Átomo del par libre(forma A #- B #)','Orbital n','')
$nbo_3 = [Microsoft.VisualBasic.Interaction]::InputBox('Número NBO del orbital pi*','Orbital pi*','')
$nbo_4 = [Microsoft.VisualBasic.Interaction]::InputBox('Átomo 1 del Enlace pi* (forma A #- B #)','Orbital pi*','')
$nbo_5 = [Microsoft.VisualBasic.Interaction]::InputBox('Átomo 2 del Enlace pi* (forma A #- B #)','Orbital pi*','')
#$nbo_2 = Read-Host -Prompt 'Átomo o enlace n (forma A #- B #)'
#$nbo_3 = Read-Host -Prompt 'Número NBO del orbital pi*'
#$nbo_4 = Read-Host -Prompt 'Átomos del Enlace pi* (forma A #- B #)'#>
if ($null -ne $nbo_1, $nbo_2, $nbo_3, $nbo_4 ){
    Write-Host "Se buscará E2, F <i j> y gap para los siguientes en $file :"
    Write-Host " Orbital n: $nbo_1. LP $nbo_2 "
    Write-Host " Orbital pi*: $nbo_3. BD* $nbo_4- $nbo_5"
} else {
    Write-Warning -Message "Parámetros incorrectos"
    [System.Windows.MessageBox]::Show("Error en captura de datos",'Error','OK',16)
    Exit
}

#Read-Host "Ruta de la carpeta con el archivo" #nos situamos en la carpeta #
Set-Location "$path"
$out= Get-ChildItem "$file" 
$out=$out.Name
#Read-Host "Nombre del archivo de salida con extensión (.out)" # elegimos qué archivo queremos
$found= Select-String $out -Pattern "$nbo_1(.*?)$nbo_2(\s.*?)$nbo_3(.*?)$nbo_4(.*?)$nbo_5" -Quiet
<# realizamos una prueba para ver primero si el patrón está ahí
si está, realiza la búsqueda para imprimir en un archivo#>
if ($found -eq $true){
    $sal=Get-ChildItem "$file"
    $sal=$sal.BaseName
    #[regex]::Matches("$out","\d[\d]").value #uso de regular expressions para extraer el numero de un string
    [System.Windows.MessageBox]::Show("Patrón encontrado en archivo $sal, imprimiendo resultados",'Aviso','OK',64)
    (Select-String -Pattern "Donor" -Context 1,2  $out && #busqueda doble en el archivo 
    Select-String -Pattern "$nbo_1(.*?)$nbo_2(\s.*?)$nbo_3(.*?)$nbo_4(.*?)$nbo_5" $out)| Out-File $path\$sal-E2pert.txt 
}
else {
    Write-Warning -Message "Patrón no encontrado"
    [System.Windows.MessageBox]::Show("Patrón no encontrado, favor de intentarlo de nuevo",'Error','OK',16)
    Exit
}
$msgboxinput =[System.Windows.MessageBox]::Show("¿Abrir archivo de salida? $sal-E2pert",'Aviso',4,64)
    switch ($msgboxinput) {
        'Yes' {C:\Windows\notepad.exe "$sal-E2pert"}
        'No' {Exit}
    }
<#$yes= New-Object System.Management.Automation.Host.ChoiceDescription '&Sí', 'Ver archivo de salida'
$nope= New-Object System.Management.Automation.Host.ChoiceDescription '&No', 'Salir del script'
$options=[System.Management.Automation.Host.ChoiceDescription[]]($yes,$nope)
$titulo="Archivo de salida"
$mensaje="¿Desea ver el archivo de salida?"
$reslt=$host.UI.PromptForChoice($titulo,$mensaje,$options,0)
switch ($reslt) {
    0 { Get-Content $pwd\$sal-E2pert.txt }
    1 {Exit}
}#>

