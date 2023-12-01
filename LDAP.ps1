using namespace System
using namespace System.DirectoryServices


# !!!!! classes are CASE SENSITIVE

#region user

# Get user from AD using LDAP
# user whose groups we want to get
[string]$userName = $env:USERNAME

[DirectoryEntry]$dirEntry = [DirectoryEntry]::new()
[DirectorySearcher]$DirSearcher = [DirectorySearcher]::new($dirEntry)

# set up LDAP-filter query
[string]$ldapFilter = "(&(objectCategory=user)(objectClass=user)(SamAccountName=$($userName)))"

$DirSearcher.Filter = $ldapFilter
$user = $DirSearcher.FindOne()

cls

# print to console name and distinguishedname of gotten user
[Console]::WriteLine("Name = $($user.Properties.name)")
[Console]::WriteLine("distinguishedname =$($user.Properties.distinguishedname)")

# get user's groups
$groups = $user.Properties.memberof

# print groups where users is consist
$groups | Select-Object @{
    Name = "GroupName";
    expression={[string]$_.split(',')[0].replace("CN=",[string]::Empty)}
}

#endregion user

#region group
# Get group info
[string]$groupName = "Event Log Readers"

[DirectoryEntry]$dirEntry = [DirectoryEntry]::new()
[DirectorySearcher]$DirSearcher = [DirectorySearcher]::new($dirEntry)

# set up LDAP-filter query
[string]$ldapFilter = "(&(objectCategory=group)(objectClass=group)(cn=$($groupName)))"

$DirSearcher.Filter = $ldapFilter
$group = $DirSearcher.FindOne()

cls
# print to console common group name 
[Console]::WriteLine("Group:`t'$($group.Properties.cn)'")

# print to console first 5 members
$group.Properties.member | Select-Object -First 5 | ForEach-Object{
    [Console]::WriteLine($_)
}

#endregion group