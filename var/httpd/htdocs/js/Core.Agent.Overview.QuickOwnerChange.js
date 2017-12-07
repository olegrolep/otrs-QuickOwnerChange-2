// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Overview = Core.Agent.Overview || {}

/**
 * @namespace Core.Agent.Overview.QuickOwnerChange
 * @memberof Core.Agent.Overview
 * @author OTRS AG
 * @description
 *      Action row functionality.
 */
Core.Agent.Overview.QuickOwnerChange = (function (TargetNS) {

  /**
   * @private
   * @name TicketElementSelectors
   * @memberof Core.Agent.Overview.QuickOwnerChange
   * @member {Object}
   * @description
   *      The ticket element selectors for the different overviews.
   */
  var TicketElementSelectors = {
        'Small': 'div.Overview table td input[type="checkbox"][name=TicketID]',
        'Medium': 'ul.Overview input[type="checkbox"][name=TicketID]',
        'Large': 'ul.Overview input[type="checkbox"][name=TicketID]'
      },

      /**
       * @private
       * @name TicketView
       * @memberof Core.Agent.Overview.QuickOwnerChange
       * @member {Object}
       * @description
       *      The active ticket view.
       */
      TicketView;

  /**
   * @name Init
   * @memberof Core.Agent.Overview.QuickOwnerChange
   * @function
   * @description
   *      This function initializes the complete ActionRow functionality and binds all click events.
   */
  TargetNS.Init = function () {
    // Get used ticket view mode
    if ($('#TicketOverviewMedium').length) {
      TicketView = 'Medium';
    }
    else if ($('#TicketOverviewLarge').length) {
      TicketView = 'Large';
    }
    else {
      TicketView = 'Small';
    }

    $('#QuickOwnerChangeBulk').off('change');

    $('#QuickOwnerChangeBulk').on('change', function () {
      var $Element = $(this),
          $SelectedTickets,
          TID = $(this).val(),
          CloseForm = $('#quickownerchangebulk'),
          URL = Core.Config.Get('Baselink');

      if (TID) {
        $SelectedTickets = $(TicketElementSelectors[TicketView] + ':checked');
        $SelectedTickets.each(function () {
          var HiddenField = $('<input type="hidden" name="TicketID">');
          HiddenField.val($(this).val());
          CloseForm.append(HiddenField);
        });
        CloseForm.submit();
      }
    });
  };

  Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

  return TargetNS;
}(Core.Agent.Overview.QuickOwnerChange || {}));
