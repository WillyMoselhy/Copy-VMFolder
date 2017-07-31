# Copy-VMFolder
A PowerShell function that copies the contents of an entire folder into a VM.

Note that the function will not copy or create empty folders.

Example:

    Copy-VMFolder -VMName ExampleVM -SourceFolderPath D:\Sources\Example -DestinationFolderPath C:\

This will create a new folder on the VM under C:\ named Example and copy all contents of D:\Source\Example on host to C:\Example on VM.
