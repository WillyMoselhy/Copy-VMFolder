function Copy-VMFolder
{
    <#
    .NOTES
        Created by Walid AlMoselhy - July 31, 2017
    .SYNOPSIS
        Copies a complete folder from host to VM.
    .DESCRIPTION
        Copies a complete folder from host to VM.
        Note that the function will not copy or create empty folders.
    .PARAMETER VMName
        Name of the virtual machine.
    .PARAMETER SourceFolderPath
        Full path to the folder you want to copy to the VM.
    .PARAMETER DestinationFolerPath
        Full path to the destination on VM.
    .EXAMPLE
         Copy-VMFolder -VMName ExampleVM -SourceFolderPath D:\Sources\Example -DestinationFolderPath C:\

         This will create a new folder on the VM under C:\ named Example and copy all contents of D:\Source\Example on host to C:\Example on VM.
         
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateScript({
            #Validate Hyper-V module is installed
            if (Get-Module -Name Hyper-V) {$true} else {Throw "Hyper-V Module is not installed."}
            #Validate VM exists on host.
            if (Get-VM -Name $_ -ErrorAction SilentlyContinue){$true} else {Throw "VM ($_) does not exist on host."}
            })]
        [string]$VMName,

        [Parameter(Mandatory=$true,Position=2)]
        [ValidateScript({
            if(Test-Path -Path $_) {$true} else {Throw "Source Folder does not exist."}
            if((get-Item -Path $_).GetType().Name -eq "DirectoryInfo") {$true} else {Throw "Source must be a directory."}
            })]
        [string]$SourceFolderPath,

        [Parameter(Mandatory=$true,Position=3)]
        [ValidateNotNull()]
        [string]$DestinationFolderPath


    )

    begin{
        $SourceFolder = Get-Item -Path $SourceFolderPath
        $SourceFolderContent = Get-ChildItem -Path $SourceFolderPath -Recurse | Where-Object {$_.GetType().Name -eq "FileInfo"}
        
        if($DestinationFolderPath.EndsWith("\")) {$DestinationFolder = $DestinationFolderPath.Substring(0,$DestinationFolderPath.Length-1)}
        else {$DestinationFolder = $DestinationFolderPath}
        
        
        foreach ($File in $SourceFolderContent){
            $DestinationPath = ($DestinationFolder + "\" +$SourceFolder.Name  + $File.FullName.Replace($SourceFolder.FullName,""))
            
            Copy-VMFile $VMName -FileSource Host -SourcePath $File.FullName -DestinationPath $DestinationPath -CreateFullPath
        }
    }
}