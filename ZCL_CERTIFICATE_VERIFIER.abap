CLASS zcl_certificate_verifier DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS verify_certificate
      IMPORTING
        iv_certificate_id TYPE zegov_e_certificate_id
      EXPORTING
        ev_valid   TYPE abap_bool
        ev_message TYPE char150.

ENDCLASS.


CLASS zcl_certificate_verifier IMPLEMENTATION.

  METHOD verify_certificate.

    DATA: ls_application TYPE zgov_citizen_app.

    ev_valid   = abap_false.
    ev_message = 'Certificate is invalid'.

    IF iv_certificate_id IS INITIAL.
      ev_message = 'Certificate ID is mandatory'.
      RETURN.
    ENDIF.

    SELECT SINGLE *
      FROM zgov_citizen_app
      INTO @ls_application
      WHERE certificate_id = @iv_certificate_id.

    IF sy-subrc <> 0.
      ev_message = 'Certificate not found'.
      RETURN.
    ENDIF.

    IF ls_application-cert_status = 'CERT_GENERATED'.

      ev_valid   = abap_true.
      ev_message = 'Certificate is valid'.

    ELSE.

      ev_message = 'Certificate is not active'.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
