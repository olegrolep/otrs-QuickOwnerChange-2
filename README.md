This is a remastered version of QuickOwnerChange addon made by
Renee Baecker https://github.com/reneeb/otrs-QuickOwnerChange

QuickOwnerChange addon - adds dropdown to quickly change ticket owner:
- Ticket Queue overview:
  - in bulk for medium and large views
  - per ticket via popup in medium and large views
  - selecting only one ticket checkbox in small view
- Ticket Zoom: per currently viewed ticket

Also, in Ticket Queue Overview, Bulk QuickOwnerChange also available
for My Queues view, where base queue is selected as one of agent's queues.

Changes to otrs native files are required - for overview and zoom templates, and zoom module.
Original files (name *._orig)  and their new patched version are included in Custom directory.
As original files may differ (based on version, etc), it is suggested to add changes individually.
You can use apply-patch.sh script, which copies (without overwriting) required native files to Custom dir
and runs git apply --check (script is required to be placed in otrs home dir (/opt/otrs).


Installation:
- Install provided QuickOwnerChange-6.0.1.opm package
OR
- build .opm package out of this repo and install it

- Install Custom changes to native otrs files, either by:
  - manually editing files - recommended
  - copying all files in Custom directory to Custom directory in otrs
  - or copying native files and making changes in them individually

- In otrs web - admin interface - system configuration
add custom .js to be loaded for ticket queue and ticket zoom screens:
 - Loader::Module::AgentTicketQueue###002-Ticket
   JavaScript - Core.Agent.Overview.QuickOwnerChange.js
 - Loader::Module::AgentTicketZoom###002-Ticket
   JavaScript - Core.Agent.TicketZoom.QuickOwnerChange.js


For OTRS 6. Probably should work with OTRS 5, but not tested.

Some changes from original version by Renee:
- permission check checks for 'owner' perms, nor 'ro'
- per ticket dropdown in medium and large view
- dropdown only for sigle ticket selection in small view
- in My Queues view dropdown also available (permissions based on one of user queues, probably with least id)
- redirect back to zoom view if change was made in zoom view
