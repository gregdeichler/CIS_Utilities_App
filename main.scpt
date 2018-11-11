set mychoice to (choose from list {"1. Set User Folder Permissions", "2. Make User an Admin", "3. Change Computer Name", "4. Force a JAMF Policy Check", "5. Force User Folder Creation", "6. Fix Filevault Password Sync Issues"} with title ("CIS Utilities") default items "None" OK button name {"Select"} cancel button name {"Cancel"})
if mychoice is {"1. Set User Folder Permissions"} then
	set the_results to (display dialog ("What is the Username?") with title ("Fix Network User Folder Permissions") default answer "" buttons {"Cancel", "Fix Permissions"} default button "Fix Permissions" with icon path to resource "user.icns" in bundle (path to me))
	set buttonReturned to button returned of the_results
	set username1 to text returned of the_results
	if buttonReturned is "Cancel" then
		error number -128 -- user canceled
	else
		do shell script "chown -Rv " & username1 & " /Users/" & username1 & "" with administrator privileges
	end if
else
	if mychoice is {"2. Make User an Admin"} then
		set the_results to (display dialog ("What is the Username?") with title ("Make Network Account a Local Administrator") default answer "" buttons {"Cancel", "Make Admin"} default button "Make Admin" with icon path to resource "user.icns" in bundle (path to me))
		set buttonReturned to button returned of the_results
		set username2 to text returned of the_results
		if buttonReturned is "Cancel" then
			error number -128 -- user canceled
		else
			do shell script "dseditgroup -o edit -n /Local/Default -u vassarjamf -P jamfjamfjamfjamf -a " & username2 & " -t user admin" with administrator privileges and password
		end if
	else
		if mychoice is {"3. Change Computer Name"} then
			set the_results to (display dialog ("Enter The New Computer Name") with title ("Update Computer Name") default answer "" buttons {"Cancel", "Change Name"} default button "Change Name" with icon path to resource "cpu.icns" in bundle (path to me))
			set buttonReturned to button returned of the_results
			set computername to text returned of the_results
			if buttonReturned is "Cancel" then
				error number -128 -- user canceled
			else
				do shell script "/usr/local/bin/jamf setComputerName -name \"" & computername & "\"" with administrator privileges
			end if
		else
			if mychoice is {"4. Force a JAMF Policy Check"} then
				set the_results to (display dialog ("Check-in with JAMF?") with title ("Force JAMF Policy Check") buttons {"Cancel", "Check-in"} default button "Check-in" with icon path to resource "jamf.icns" in bundle (path to me))
				set progress description to "Please Wait..."
				set buttonReturned to button returned of the_results
				set progress description to "Please Wait..."
				if buttonReturned is "Cancel" then
					error number -128 -- user canceled
				else
					set progress total steps to 2
					set progress completed steps to 1
					set progress description to "Scanning Local Computer"
					set progress additional description to "Running JAMF Recon"
					do shell script "/usr/local/bin/jamf recon" with administrator privileges
					set progress description to "Checking for Available JAMF Policies"
					set progress additional description to "Running JAMF Policy Check"
					set progress completed steps to 2
					do shell script "/usr/local/bin/jamf policy" with administrator privileges
				end if
			else
				if mychoice is {"5. Force User Folder Creation"} then
					set the_results to (display dialog ("What is the Username?") with title ("Force User Home Folder Creation") default answer "" buttons {"Cancel", "Create Folder"} default button "Create Folder" with icon path to resource "user.icns" in bundle (path to me))
					set buttonReturned to button returned of the_results
					set username3 to text returned of the_results
					if buttonReturned is "Cancel" then
						error number -128 -- user canceled
					else
						set selectedUser to text returned of the_results
						set migrationCommand to (path to resource "CreateFolder.command") as string
						set commandPath to "Macintosh HD:Users:Shared:"
						with timeout of (180 * 180) seconds
							tell application "Finder"
								duplicate alias migrationCommand to commandPath with replacing
							end tell
						end timeout
						do shell script "sed -i.bu 's/REPLACEME/selectedUser=" & selectedUser & "/' " & "/Users/Shared/CreateFolder.command"
						do shell script "open /Users/Shared/CreateFolder.command"
						
					end if
				else
					if mychoice is {"6. Fix Filevault Password Sync Issues"} then
						display dialog ("Coming Soon!") buttons {"Cancel", "Whatever"} default button "Whatever"
					else
						error number -128 -- user canceled
					end if
				end if
			end if
		end if
	end if
end if
