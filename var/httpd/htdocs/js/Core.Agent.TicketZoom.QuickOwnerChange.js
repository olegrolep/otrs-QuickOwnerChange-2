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
Core.Agent.TicketZoom = Core.Agent.TicketZoom || {}

/**
 * @namespace Core.Agent.TicketZoom.QuickOwnerChange
 * @memberof Core.Agent.TicketZoom
 * @author OTRS AG
 * @description
 *      Action row functionality.
 */
Core.Agent.TicketZoom.QuickOwnerChange = (function (TargetNS) {

  /**
   * @name Init
   * @memberof Core.Agent.TicketZoom.QuickOwnerChange
   * @function
   * @description
   *      This function initializes the complete ActionRow functionality and binds all click events.
   */
  TargetNS.Init = function () {

    $('#QuickOwnerChange').bind('change', function (Event) {
      var URL = Core.Config.Get('Baselink');
      var TID = $(this).val();
      var ZoomMarker = $('<input type="hidden" name="Zoom" value=1>');

      var thisObject = $(this);

      if (TID) {
        thisObject.closest('form').append(ZoomMarker);
        thisObject.closest('form').submit();
      }
    });
  };

  Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

  return TargetNS;
}(Core.Agent.TicketZoom.QuickOwnerChange || {}));
