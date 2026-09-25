CLASS zcl_document_verification DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS verify_document
      IMPORTING
        iv_application_id TYPE zegov_e_application_id
        iv_document_id    TYPE zegov_e_document_id
        iv_document_type  TYPE char30
      EXPORTING
        ev_verified TYPE abap_bool
        ev_message  TYPE char150.

ENDCLASS.


CLASS zcl_document_verification IMPLEMENTATION.

  METHOD verify_document.

    ev_verified = abap_false.
    ev_message  = 'Document verification failed'.

    IF iv_application_id IS INITIAL.
      ev_message = 'Application ID is mandatory'.
      RETURN.
    ENDIF.

    IF iv_document_id IS INITIAL.
      ev_message = 'Document ID is mandatory'.
      RETURN.
    ENDIF.

    IF iv_document_type IS INITIAL.
      ev_message = 'Document Type is mandatory'.
      RETURN.
    ENDIF.

    ev_verified = abap_true.
    ev_message  = 'Document verified successfully'.

  ENDMETHOD.

ENDCLASS.
