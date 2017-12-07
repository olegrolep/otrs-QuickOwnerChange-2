#!/bin/bash
mkdir -p Custom/Kernel/Modules
mkdir -p Custom/Kernel/Output/HTML/Templates/Standard
cp -n Kernel/Modules/AgentTicketZoom.pm Custom/Kernel/Modules/AgentTicketZoom.pm
cp -n Kernel/Output/HTML/Templates/Standard/AgentTicketOverviewPreview.tt Custom/Kernel/Output/HTML/Templates/Standard/AgentTicketOverviewPreview.tt
cp -n Kernel/Output/HTML/Templates/Standard/AgentTicketOverviewMedium.tt Custom/Kernel/Output/HTML/Templates/Standard/AgentTicketOverviewMedium.tt
cp -n Kernel/Output/HTML/Templates/Standard/AgentTicketOverviewSmall.tt Custom/Kernel/Output/HTML/Templates/Standard/AgentTicketOverviewSmall.tt
cp -n Kernel/Output/HTML/Templates/Standard/AgentTicketZoom.tt Custom/Kernel/Output/HTML/Templates/Standard/AgentTicketZoom.tt

git aplly --check --directory=Custom Custom/QuickOwnerChange.patch
