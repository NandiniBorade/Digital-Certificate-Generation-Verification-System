CLASS zcl_approval_manager DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS approve_application
      IMPORTING
        iv_application_id TYPE zegov_e_application_id
        iv_processed      TYPE abap_bool
        iv_approved       TYPE abap_bool
      EXPORTING
        ev_status  TYPE zegov_e_status
        ev_message TYPE char150.

ENDCLASS.


CLASS zcl_approval_manager IMPLEMENTATION.

  METHOD approve_application.

    ev_status  = 'REJECTED'.
    ev_message = 'Application approval failed'.

    IF iv_application_id IS INITIAL.
      ev_message = 'Application ID is mandatory'.
      RETURN.
    ENDIF.

    IF iv_processed <> abap_true.
      ev_message = 'Application is not processed'.
      RETURN.
    ENDIF.

    IF iv_approved = abap_true.

      UPDATE zgov_citizen_app
         SET status = 'APPROVED'
       WHERE aaplication_id = @iv_application_id.

      IF sy-subrc = 0.
        COMMIT WORK.
        ev_status  = 'APPROVED'.
        ev_message = 'Application approved successfully'.
      ELSE.
        ROLLBACK WORK.
        ev_message = 'Application not found or approval failed'.
      ENDIF.

    ELSE.

      UPDATE zgov_citizen_app
         SET status = 'REJECTED'
       WHERE aaplication_id = @iv_application_id.

      IF sy-subrc = 0.
        COMMIT WORK.
        ev_status  = 'REJECTED'.
        ev_message = 'Application rejected'.
      ELSE.
        ROLLBACK WORK.
        ev_message = 'Application not found or rejection failed'.
      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
