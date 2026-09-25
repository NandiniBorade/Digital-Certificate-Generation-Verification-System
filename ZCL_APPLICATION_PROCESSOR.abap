CLASS zcl_application_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS process_application
      IMPORTING
        iv_application_id    TYPE zegov_e_application_id
        iv_validated         TYPE abap_bool
        iv_document_verified TYPE abap_bool
      EXPORTING
        ev_processed TYPE abap_bool
        ev_message   TYPE char150.

ENDCLASS.


CLASS zcl_application_processor IMPLEMENTATION.

  METHOD process_application.

    ev_processed = abap_false.
    ev_message   = 'Application processing failed'.

    IF iv_application_id IS INITIAL.
      ev_message = 'Application ID is mandatory'.
      RETURN.
    ENDIF.

    IF iv_validated <> abap_true.
      ev_message = 'Application data validation failed'.
      RETURN.
    ENDIF.

    IF iv_document_verified <> abap_true.
      ev_message = 'Document verification failed'.
      RETURN.
    ENDIF.

    UPDATE zgov_citizen_app
       SET status = 'PROCESSING'
     WHERE aaplication_id = @iv_application_id.

    IF sy-subrc = 0.

      COMMIT WORK.

      ev_processed = abap_true.
      ev_message   = 'Application processed successfully'.

    ELSE.

      ROLLBACK WORK.
      ev_message = 'Application not found or update failed'.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
