CLASS zcl_application_manager DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS create_application
      IMPORTING
        iv_citizen_id TYPE zegov_e_citizen_id
        iv_cert_type  TYPE zegov_e_cert_type
      EXPORTING
        ev_application_id TYPE zegov_e_application_id
        ev_status         TYPE zegov_e_status.

ENDCLASS.


CLASS zcl_application_manager IMPLEMENTATION.

  METHOD create_application.

    DATA: ls_application TYPE zgov_citizen_app.

    ev_application_id = |APP{ sy-datum+2(6) }{ sy-uzeit }|.
    ev_status = 'REJECTED'.

    SELECT SINGLE *
      FROM zgov_citizen_app
      INTO @ls_application
      WHERE citizen_id = @iv_citizen_id.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    ls_application-aaplication_id   = ev_application_id.
    ls_application-certificate_type = iv_cert_type.
    ls_application-application_date = sy-datum.
    ls_application-status           = 'SUBMITTED'.

    MODIFY zgov_citizen_app FROM ls_application.

    IF sy-subrc = 0.
      COMMIT WORK.
      ev_status = 'SUBMITTED'.
    ELSE.
      ROLLBACK WORK.
      ev_status = 'REJECTED'.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
