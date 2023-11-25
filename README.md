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

When running the scripts individually, the VM can be kept running to use for debugging in the Lazarus IDE, via Remote Desktop, if there are Windows-specific issues.

There is also the `az-run-all.ps1` script which executes all the steps from provisioning through deleting the resource group.

---

More details to come... (although distraction is a possibility ;-)
