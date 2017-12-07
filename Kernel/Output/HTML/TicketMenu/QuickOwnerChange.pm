# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketMenu::QuickOwnerChange;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::Config',
    'Kernel::System::Ticket',
    'Kernel::System::Group',
    'Kernel::System::User',
    'Kernel::System::Queue',
    'Kernel::Output::HTML::Layout',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    if (!$Param{Ticket}) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'Need Ticket!'
        );
        return;
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if frontend module registered, if not, do not show action
    if ($Param{Config}->{Action}) {
        my $Module = $ConfigObject->Get('Frontend::Module')->{ $Param{Config}->{Action} };
        return if !$Module;
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    my %Ticket = $TicketObject->TicketGet(
        TicketID => $Param{Ticket}->{TicketID},
        UserID   => $Self->{UserID},
    );

    # check that user has owner change permissions for the ticket
    my $Access = $TicketObject->TicketPermission(
        Type     => 'owner',
        TicketID => $Param{Ticket}->{TicketID},
        UserID   => $Self->{UserID}
    );

    return if !$Access;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %ViewPermissions = %{ $ConfigObject->Get('QuickOwnerChange::ViewPermission') || {} };
    if ($ViewPermissions{ $Ticket{Queue} }) {
        my (@Groups) = split /\s*,\s*/, $ViewPermissions{ $Ticket{Queue} };

        my $IsAllowed = grep {$LayoutObject->{"UserIsGroup[$_]"}}@Groups;
        return if !$IsAllowed;
    }

    my @GroupPermissions = @{ $ConfigObject->Get('QuickOwnerChange::ViewPermissionByGroup') || [] };
    if (@GroupPermissions) {
        my $IsAllowed = grep {$LayoutObject->{"UserIsGroup[$_]"}}@GroupPermissions;
        return if !$IsAllowed;
    }

    # check acl
    my %ACLLookup = reverse(%{ $Param{ACL} || {} });
    return if (!$ACLLookup{ $Param{Config}->{Action} });

    $Param{Link} = 'Action=AgentTicketQuickOwnerChange;TicketID=[% Data.TicketID | uri %];';

    if ($ConfigObject->Get('Ticket::Frontend::MoveType') =~ /^form$/i) {
        $Param{Target} = '';
        $Param{Block} = 'DocumentMenuItemQuickOwnerChangeForm';

        my $GroupID = $QueueObject->GetQueueGroupID(
            QueueID => $Ticket{QueueID},
        );

        my $AgentGroup = $ConfigObject->Get('QuickOwnerChange::OwnerGroup');
        if ($AgentGroup) {
            $GroupID = $GroupObject->GroupLookup(Group => $AgentGroup);
        }

        my $QueueAgentGroup = $ConfigObject->Get('QuickOwnerChange::QueueGroups') || {};
        if ($QueueAgentGroup && $QueueAgentGroup->{ $Ticket{Queue} }) {
            my $GroupName = $QueueAgentGroup->{ $Ticket{Queue} };
            $GroupID = $GroupObject->GroupLookup(Group => $GroupName);
        }

        my $Type = $ConfigObject->Get('QuickOwnerChange::Permissions') || 'rw';
        my %User = $GroupObject->GroupMemberList(
            GroupID => $GroupID,
            Type    => $Type,
            Result  => 'HASH',
        );

        $User{$_} = $UserObject->UserName(UserID => $_) for keys %User;

        my @Data = map {{ Key => $_, Value =>
            $User{$_} }}sort {$User{$a} cmp $User{$b}}keys %User;

        my $Label = $ConfigObject->Get('QuickOwnerChange::NoneLabel') || 'Quick Owner Change';

        unshift @Data, {
                Key   => '0',
                Value =>
                ' - ' . $LayoutObject->{LanguageObject}->Translate($Label) . ' - ',
            };

        $Param{NewOwnerStrg} = $LayoutObject->BuildSelection(
            Name  => 'QuickOwnerChange',
            Data  => \@Data,
            Class => 'Modernize',
        );

    }
    else {
        $Param{PopupType} = 'TicketAction';
    }

    # return item
    return { %{ $Param{Config} }, %{ $Param{Ticket} }, %Param };
}

1;
