# provision-windows

**ATTENTION:** This repository is now defunct.  I have moved all Windows provisioning scripts\steps\settings to my [Winfiles](https://github.com/brennanfee/winfiles) repository.  It is simpler and more self-contained.

---

This is a [BoxStarter](http://boxstarter.org) based set of scripts for provisioning my Windows machines (both personal and work related).

## Steps to provision

This repo contains a "main" BoxStarter script which can be bootstrapped by BoxStarter itself using a simple URL.  This way, you can simply open PowerShell and paste in the following command:

`START http://boxstarter.org/package/url?https://git.io/vND3v`

If you fork this repository you will need to follow the steps described blow in the section [Steps to set up your own fork](README.md#steps-to-set-up-your-own-fork) which includes using a different URL after the `?` above.

When executed, BoxStarter will first prompt for security permissions and then for the account password needed for reboots to occur.  After a **LONG** while and many reboots (thanks Microsoft! :rage:) the machine should have the base needed to proceed with further setup and installation(s).

## Steps after provisioning

As I have configured here, a number of extra windows features are turned on, some Microsoft provided "bloatware" is removed, and a few "universal" applications are installed.  At present, I don't use this script to "fully" configure my machines and install *every* application or system setting I might want to use.  Essentially this script includes anything that requires reboot resiliency and lots of time (like Windows Updates) or anything that I would put on every Windows machine regardless of desired purpose for the machine (such as Google Chrome).  This serves as a proper "base" not a fully configured machine.  Of course, you could change\extend the setup as described elsewhere in this document in order to accomplish that.

After running this bootstrap script you can then use [Chocolatey](https://chocolatey.org) and/or PowerShell to install further applications and adjust settings.

Personally, I use a second repository called [WinFiles](https://github.com/brennanfee/winfiles) to house my system settings and application settings (sort of like a [dotfiles](https://dotfiles.github.io/) repository for Linux but for Windows).  I also put PowerShell scripts in that repository to automate the installation of the rest of my preferred system settings and applications that this bootstrap script does not include.  On top of all that, my [WinFiles](https://github.com/brennanfee/winfiles) repository includes [my Linux dotfiles](https://github.com/brennanfee/dotfiles) as a submodule repository in order to share some settings files across all of my machines whether Windows, Mac, or Linux (such as my Vim settings).

## Project Structure

The main BoxStarter script is found in [BoxStarter-Setup.ps1](boxStarter/Boxstarter-Setup.ps1).  This is the script that you should point BoxStarter at for it to run directly.  It is ideal to use a URL shortener to make this easier.  Part of what that script does is pull this repository as a zip file and then use the other scripts provided to run and perform the various tasks (it doesn't use Git because part of what this script does is install Git - chicken, meet egg).

The scripts in the [Installs](scripts/Installs) directory are called directly by [BoxStarter-Setup.ps1](boxStarter/Boxstarter-Setup.ps1).  So adding a file to that directory requires an update to that script.

The scripts in [Bloat](scripts/Bloat), [Settings](scripts/Settings), and [Other](scripts/Other) directories, however, are all called in sequence so simply adding a new file in one of those directories means it will get called automatically (the file must have a ps1 extension).  The [Bloat](scripts/Bloat) directory is intended for removing Windows bloat software, such as OneDrive.  The [Settings](scripts/Settings) directory is intended to adjust system Registry settings.  Lastly, the [Other](scripts/Other) directory is reserved as an extension point for other scripts that need to run near the end of the process.

The file [chocolatey-packages.config](scripts/chocolatey-packages.config) houses the list of Chocolatey provided applications to install.  This list of applications is installed **before** the [Other](scripts/Other) scripts are run so the installation of the applications can be assumed in the [Other](scripts/Other) scripts.

### List of default applications

Here is the list of applications that are installed by default.

* Chocolatey - Obviously required as this is what BoxStarter is based on.
* Git - A source control\version control management utility.  Needed immediately after install to get my [WinFiles](https://github.com/brennanfee/winfiles).
* Which - A command line utility that mirrors the behavior of the Linux `which` command.
* VLC - A popular open source media player (audio and video).
* Google Chrome - **THE** web browser because who still uses IE right!?!
* 7zip.portable - To "unzip" ISO files and Zip files.  This is the portable version which makes it particularly useful for scripted situations.  This is potentially used during installation on virtual machines.
* Sysinternals - A set of Microsoft utilities.  One of which is used during installation on virtual machines.

## Steps to set up your own fork

After forking this repository here are the minimum steps you should perform to have your own customized setup.

1. Get the raw content URL to the [BoxStarter-Setup.ps1](boxStarter/Boxstarter-Setup.ps1) script for your repo.
1. Update this README to modify the URL in the START command above. Simply replace the URL after the `?` symbol to point to your script (use a URL shortener if desired).
1. Modify the [chocolatey-packages.config](scripts/chocolatey-packages.config) file to install your desired applications.
1. Modify or remove any of the scripts in the [Bloat](scripts/Bloat) or [Settings](scripts/Settings) directories to adjust to your own liking.
1. Add any extra scripts you wish to the [Other](scripts/Other) directory.
1. Test provisioning a machine and verify you get the results you want. (Honestly, this can't be stressed enough.  Testing is critical.  Make sure to examine the output logs to verify that things are working correctly.)

While I only install some "core" applications and don't tweak many system settings with this set of scripts you could certainly do so.  I just feel it is a better separation of concerns to place the most important and universal things here along with the things that required BoxStarter and its reboot resiliency and to separate other more personal setup requirements and preferences (such as what wallpaper I prefer).  The other advantage to having some of the scripts run outside of BoxStarter is that BoxStarter should really only be run once on initial system configuration.  By reserving some of the scripts to be run afterward (in my [WinFiles](https://github.com/brennanfee/winfiles) setup, for instance) I can code those scripts to be able to run multiple times which makes modifying and testing them easier.

Whatever you decide to do, remember as always... [YMMV](https://dictionary.cambridge.org/us/dictionary/english/ymmv).

