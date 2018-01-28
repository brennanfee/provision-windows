# provision-windows

This is a [BoxStarter](http://boxstarter.org) based set of scripts for provisioning my Windows machines (both personal and work related).

## Steps to provision

This repo contains a "main" BoxStarter script which can be bootstrapped by BoxStarter itself using a simple URL.  This way, you can simply open PowerShell and paste in the following command:

`START http://boxstarter.org/package/url?https://git.io/vND3v`

If you fork this repository you will need to follow the steps described blow in the section [Steps to set up your own fork](README.md#steps-to-set-up-your-own-fork) which includes using a different URL after the `?` above.

This will first prompt for security permissions and then for the account password needed for reboots to occur.  After a LONG while and many reboots (thanks Microsoft! :rage:) the machine should have the base needed to proceed with further setup and installation(s).

## Steps after provisioning

As I have configured here, a number of extra windows features are turned on and a few "universal" applications are installed.  At present, I don't use this script to "fully" configure my machines and install *every* application or system setting I might want to use.  Essentially this script includes anything that requires reboot resiliency and lots of time (like Windows Updates) or anything that I would put on every Windows machine regardless of desired purpose for the machine (such as Google Chrome).  This serves as a proper "base" not a fully configured machine.  Of course, you could change\extend the setup as described elsewhere in this document in order to accomplish that.

After running this bootstrap script you can then use [Chocolatey](https://chocolatey.org) and/or PowerShell to install further applications and adjust settings.

Personally, I use a second repository called [WinFiles](https://github.com/brennanfee/winfiles) to not only house my system settings and application settings (sort of like a [dotfiles](https://dotfiles.github.io/) repository for Linux but for Windows instead) but also to automate the installation of the rest of my preferred applications that the bootstrap script does not include.  In fact, my WinFiles repository includes my Linux dotfiles as a submodule repository in order to share some settings files across all of my machines.

## Project Structure

The main BoxStarter script is found in [boxStarter/BoxStarter-Setup.ps1](boxStarter/Boxstarter-Setup.ps1).  This is the script that you should point BoxStarter at for it to run directly.  It is ideal to use a URL shortener to make this easier.  Part of what that script does is pull this repository as a zip file and then use the other scripts provided to run and perform the various tasks (it doesn't use Git because part of what this script does is install Git - chicken, meet egg).

The files in the [Installs](Installs) folder are called directly by BoxStarter-Setup.ps1.  So adding a file to that directory requires an update to that script.

The files in `Bloat` and `Other`, however, are all called in sequence so simply adding a new file in that folder (with a ps1 extension) means it will get called automatically.  [Note that the `Bloat` folder is targeted toward removing windows bloat software, such as OneDrive.  The `Other` folder is reserved as an extension point.]

The file [scripts/chocolatey-packages.config](scripts/chocolatey-packages.config) houses the list of Chocolatey provided applications to install.  This list of applications is installed **before** the `Other` scripts are run so the installation of the applications can be assumed in the `Other` scripts.

### List of default applications

Here is the list of applications that are installed by default.

* Git - A source control\version control management utility.  Needed immediately after install to get my WinFiles.
* Which - A command line utility that mirrors the Linux `which` command.
* VLC - A popular media player (audio and video).
* Google Chrome - **THE** web browser because who still uses IE!?!

The following other applications are installed and are required as part of this scripts setup.

* 7zip.portable - To "unzip" ISO files and Zip files.  Used during part of the setup in the event the machine is a virtual machine.
* Sysinternals - A set of Microsoft utilities.  One of which is used during installation on virtual machines.
* Chocolatey - Obviously required as this is what BoxStarter is based on.

## Steps to set up your own fork

After forking this repository here are the minimum steps you should perform to have your own customized setup.

1. Get the raw content URL to the BoxStarter-Setup.ps1 script for your repo.
1. Update this README to modify the URL in the START command above. Simply replace the URL after the `?` symbol to point to your script (use a URL shortener if desired).
1. Modify the [scripts/chocolatey-packages.config](scripts/chocolatey-packages.config) file to install your desired applications.
1. Add any extra scripts you wish to the `Other` folder.
1. Modify any of the other scripts to adjust to your own liking (be careful here as some may be necessary for successful completion).
1. Test provisioning a machine and verify you get the results you want.

While I only install some "core" applications and don't tweak many system settings with this set of scripts you could certainly do so.  I just felt it was a better separation of concerns to place the most important things here along with the things that required BoxStarter and its reboot resiliency from other more custom setup requirements and preferences (such as what wallpaper I prefer).  The other advantage to having some of the scripts run outside of BoxStarter is that BoxStarter should really only be run once on initial system configuration.  By reserving some of the scripts to be run afterward (in my WinFiles setup, for instance) I can code those scripts to be able to run multiple times which makes modifying and testing them easier.

Whatever you decide to do, remember as always... [YMMV](https://dictionary.cambridge.org/us/dictionary/english/ymmv).

