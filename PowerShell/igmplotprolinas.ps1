Add-Type -AssemblyName Microsoft.VisualBasic; #llamamos a las librerias necesarias para usar interfaz de usuario
Add-Type -AssemblyName PresentationCore, PresentationFramework 
Add-Type -AssemblyName System.Windows.Forms
#$path = [Microsoft.VisualBasic.Interaction]::InputBox('Ruta de la carpeta con las entradas (*.inp)','Carpeta','')
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
function Archivo  {
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $OpenFileDialog.initialDirectory = $path
        $OpenFileDialog.filter = "All files (*.*)|*.*|WaveFunction Files (*.wfn)|*.wfn|Extended WaveFunction Files (*.wfx)|*.wfx| IGMPLOT input file (*.igm)|*.igm|Text files (*.txt)|*.txt"
        $OpenFileDialog.ShowDialog() |  Out-Null
        $file=$OpenFileDialog.filename
        if ($file -ne "") 
            {Return $file} 
        else 
        {[System.Windows.MessageBox]::Show("No se eligió ningún archivo",'Error','OK',16)
        Exit}
    }
<#le pedimos al usuario la carpeta donde están los archivos
y confirmamos la eleccion#>
$path=Carpeta
$msgboxinput =[System.Windows.MessageBox]::Show("¿La carpeta $path es correcta?",'Aviso',4,64)
    switch ($msgboxinput) {
        'Yes' {Continue}
        'No' {$path=Carpeta}
    }
[System.Windows.MessageBox]::Show("La carpeta escogida es: $path",'Aviso','OK')
Out-String -InputObject $path #convertimos la entrada del usuario a un string
Set-Location "$path" #y accedemos a la carpeta que le hemos indicado
#--------------------------------------------------------------------------------------#
$file=Archivo

