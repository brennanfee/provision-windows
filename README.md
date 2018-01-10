# provision-windows

This is a [BoxStarter](http://boxstarter.org) based set of scripts for provisioning my Windows machines (both personal and work related).

## Steps to provision

At present I upload the "main" BoxStarter script to a gist to make it able to be bootstrapped by BoxStarter itself.  This way, you can simply open PowerShell and paste in the following command:

`START http://boxstarter.org/package/url?https://git.io/vF5zn`

If you fork this repository you will need to follow the steps described blow in the section [Steps to set up your own fork](https://github.com/brennanfee/provision-windows#steps-to-set-up-your-own-fork).

This will first prompt for security permissions and then for the account password needed for reboots to occur.  After a LONG while and many reboots (thanks Microsoft!) the machine should have the base needed to proceed with further setup and installation(s).

## Steps after provision

As I have configured here, these scripts only do the minimal amount of work needed to "prepare" a machine.  Essentially this includes anything that requires reboot resiliency and lots of time (like Windows Updates).

After running this script you can then use [Chocolatey](https://chocolatey.org) and/or PowerSHell to install your apps and adjust settings.

For me, I use a second repository called [WinFiles](https://github.com/brennanfee/winfiles) to not only house my system settings and application settings (like a [dotfiles](https://dotfiles.github.io/) repository for Linux) but also to automate the installation of my apps using Chocolatey.

## Project Structure

The main BoxStarter script is found in [boxStarter/BoxStarter-Setup.ps1](https://github.com/brennanfee/provision-windows/blob/master/boxStarter/Boxstarter-Setup.ps1).  This is the script that gets uploaded to the Gist and that BoxStarter runs directly.  Part of what that script does is pull this repository as a zip file and then use the other scripts provided to run and perform the various tasks (it doesn't use Git as part of what this script does is install Git - chicken, meet egg).

The files in the "Installs" folder are called directly by BoxStarter-Setup.ps1.  So adding a file to that directory requires an update to the BoxStarter-Setup.ps1 script.

The files in "Bloat" and "Other", however, are all called in sequence so simply adding a new file in that folder (with a ps1 extension) means it will get called.  [Note that the "bloat" folder is targeted toward removing windows bloat software, such as OneDrive].

If you want to extend this script you could simply add some ps1 files to the "Other" folder and they would get run as part of the bootstrap.

## Steps to set up your own fork

After forking this repository here are the minimum steps you should perform to have your own customized setup.

1. Publish the contents of Boxstarter-Setup.ps1 to your own Gist.
1. Get the link to your gist and update this README to modify the URL in the START command above after the `?` symbol.
1. Add any extra scripts you wish to the "Other" folder.
1. Modify any of the other scripts to adjust to your own liking.
1. Test provisioning a machine and verify you get the results you want.

While I don't install apps or adjust system settings with this project you could certainly do so.  I just felt it was a better separation of concerns separating that which required BoxStarter from "other" things that didn't (and essentially could or would likely be run more than just on initial bootstrap).

And as always... [YMMV](https://dictionary.cambridge.org/us/dictionary/english/ymmv).
