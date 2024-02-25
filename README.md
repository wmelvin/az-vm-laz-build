# az-vm-laz-build

This project contains **PowerShell** scripts that use the **Azure CLI** to create, run, and delete an Azure **Windows VM** to build a **Lazarus** project.

This project does not use Lazarus, or Free Pascal. It supports building a Windows executable for a separate project that does.
- [Lazarus - Website](https://www.lazarus-ide.org/)
- [Lazarus - Wikipedia](https://en.wikipedia.org/wiki/Lazarus_(software))
- [Free Pascal - Website](https://www.freepascal.org/)
- [Free Pascal - Wikipedia](https://en.wikipedia.org/wiki/Free_Pascal)

---

The [source project](https://github.com/wmelvin/ImagePicker) being built is developed using the Lazarus IDE running on Linux. A Linux executable is created in that environment. This set of scripts affords building a Windows executable, on a Windows 11 VM, using the Windows version of Lazarus, in a (mostly) automated way.

The scripts are organized in steps that can be run individually.

The `az-run-all.ps1` script executes all steps from provisioning through deleting the resource group. If all goes well, a Windows version of the Lazarus project is built from source and the resulting executable is downloaded and available locally.

The `az-run-most.ps1` script runs every step **except cleanup**. This can be used to do additional work on the VM, such as testing or debugging, via Remote Desktop.
