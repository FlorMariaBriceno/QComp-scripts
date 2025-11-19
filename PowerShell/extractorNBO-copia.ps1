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
$out= Get-ChildItem "$file" 
$out=$out.Name
$arch=Get-ChildItem "$file"
$arch=$arch.BaseName
[System.Windows.MessageBox]::Show("Introducir datos para archivo $arch",'Aviso','OK',64)
$nbo_1 = [Microsoft.VisualBasic.Interaction]::InputBox("Número NBO del par libre en $arch",'Orbital n','')
$nbo_2 = [Microsoft.VisualBasic.Interaction]::InputBox("Átomo del par libre(forma A #- B #) en $arch",'Orbital n','')
$nbo_3 = [Microsoft.VisualBasic.Interaction]::InputBox("Número NBO del orbital pi* en $arch",'Orbital pi*','')
$nbo_4 = [Microsoft.VisualBasic.Interaction]::InputBox("Átomo 1 del Enlace pi* en $arch (forma A #- B #)",'Orbital pi*','')
$nbo_5 = [Microsoft.VisualBasic.Interaction]::InputBox("Átomo 2 del Enlace pi* en $arch (forma A #- B #)",'Orbital pi*','')
#$nbo_2 = Read-Host -Prompt 'Átomo o enlace n (forma A #- B #)'
#$nbo_3 = Read-Host -Prompt 'Número NBO del orbital pi*'
#$nbo_4 = Read-Host -Prompt 'Átomos del Enlace pi* (forma A #- B #)'#>
if ("" -ne $nbo_1, $nbo_2, $nbo_3, $nbo_4 ){
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
    $var1=(Select-String -Pattern "\d[.]+\d\d[\d]*" -AllMatches .\$sal-E2pert.txt).Matches
    $var2=Get-ChildItem .\$sal-E2pert.txt
    #manejo de matrices de informacion
    $var2| Format-Table -AutoSize Name, @{Label="E2"; Expression={$var1[0]}}, @{Label="Gap"; Expression={$var1[1]}},
        @{Label="Fock matrix"; Expression={$var1[2]}} >> $pwd\E2pert-table.txt}
else {
    Write-Warning -Message "Patrón no encontrado"
    [System.Windows.MessageBox]::Show("Patrón no encontrado, favor de intentarlo de nuevo",'Error','OK',16)
    Exit
}
$msgboxinput =[System.Windows.MessageBox]::Show("¿Abrir archivo de salida? $sal-E2pert",'Aviso',4,64)
    switch ($msgboxinput) {
        'Yes' {C:\Windows\notepad.exe "$sal-E2pert.txt"}
        'No' {Exit}
    }

