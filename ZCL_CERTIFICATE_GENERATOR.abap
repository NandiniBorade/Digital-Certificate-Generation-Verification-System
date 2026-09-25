CLASS zcl_certificate_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS generate_certificate
      IMPORTING
        iv_application_id TYPE zegov_e_application_id
        iv_approved       TYPE abap_bool
      EXPORTING
        ev_certificate_id TYPE zegov_e_certificate_id
        ev_status         TYPE zegov_e_status
        ev_message        TYPE char150.

ENDCLASS.


CLASS zcl_certificate_generator IMPLEMENTATION.

  METHOD generate_certificate.

    DATA: ls_application TYPE zgov_citizen_app.

    ev_certificate_id = ''.
    ev_status         = 'REJECTED'.
    ev_message        = 'Certificate generation failed'.

    IF iv_application_id IS INITIAL.
      ev_message = 'Application ID is mandatory'.
      RETURN.
    ENDIF.

    IF iv_approved <> abap_true.
      ev_message = 'Application is not approved'.
      RETURN.
    ENDIF.

    ev_certificate_id = |CRT{ sy-datum+2(6) }{ sy-uzeit }|.

    SELECT SINGLE *
      FROM zgov_citizen_app
      INTO @ls_application
      WHERE aaplication_id = @iv_application_id.

    IF sy-subrc <> 0.
      ev_certificate_id = ''.
      ev_message = 'Application not found'.
      RETURN.
    ENDIF.

    ls_application-certificate_id = ev_certificate_id.
    ls_application-issue_date    = sy-datum.
    ls_application-cert_status   = 'CERT_GENERATED'.

    MODIFY zgov_citizen_app FROM ls_application.

    IF sy-subrc = 0.

      COMMIT WORK.

      ev_status  = 'CERT_GENERATED'.
      ev_message = 'Digital certificate generated successfully'.

    ELSE.

      ROLLBACK WORK.

      ev_certificate_id = ''.
      ev_status         = 'REJECTED'.
      ev_message        = 'Certificate generation failed'.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
