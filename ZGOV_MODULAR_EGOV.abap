*&---------------------------------------------------------------------*
*& Report ZGOV_MODULAR_EGOV
*&---------------------------------------------------------------------*
REPORT zgov_modular_egov.

DATA: gv_citizen_id   TYPE zegov_e_citizen_id,
      gv_citizen_name TYPE char60,
      gv_dob          TYPE dats,
      gv_mobile_no    TYPE char10,
      gv_email        TYPE char100,
      gv_address      TYPE char100.

DATA: gv_application_id   TYPE zegov_e_application_id,
      gv_certificate_type TYPE zegov_e_cert_type,
      gv_status           TYPE zegov_e_status,
      gv_application_date TYPE dats.

DATA: gv_document_id         TYPE zegov_e_document_id,
      gv_document_type       TYPE char30,
      gv_verification_status TYPE char25,
      gv_verification_remark TYPE char100.

DATA: gv_certificate_id TYPE zegov_e_certificate_id,
      gv_cert_status    TYPE zegov_e_status,
      gv_issue_date     TYPE dats.

START-OF-SELECTION.
  CALL SCREEN 0100.


MODULE status_0100 OUTPUT.

  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR 'TITLE_0100'.

ENDMODULE.


MODULE user_command_0100 INPUT.

  CASE sy-ucomm.

    WHEN 'REGISTER'.
      PERFORM register_citizen.

    WHEN 'CREATE_APP'.
      PERFORM create_application.

    WHEN 'VALIDATE'.
      PERFORM validate_data.

    WHEN 'VERIFY_DOC'.
      PERFORM verify_document.

    WHEN 'PROCESS'.
      PERFORM process_application.

    WHEN 'APPROVE'.
      PERFORM approve_application.

    WHEN 'GENERATE_CERT'.
      PERFORM generate_certificate.

    WHEN 'VERIFY_CERT'.
      PERFORM verify_certificate.

    WHEN 'CLEAR'.
      PERFORM clear_screen.

    WHEN 'EXIT'.
      LEAVE PROGRAM.

  ENDCASE.

ENDMODULE.


FORM register_citizen.

  DATA: lo_registration TYPE REF TO zcl_citizen_registration.

  CREATE OBJECT lo_registration.

  lo_registration->register_citizen(
    EXPORTING
      iv_citizen_id   = gv_citizen_id
      iv_citizen_name = gv_citizen_name
      iv_dob          = gv_dob
      iv_mobile       = gv_mobile_no
      iv_email        = gv_email
      iv_address      = gv_address ).

ENDFORM.


FORM create_application.

  DATA: lo_application TYPE REF TO zcl_application_manager.

  CREATE OBJECT lo_application.

  lo_application->create_application(
    EXPORTING
      iv_citizen_id = gv_citizen_id
      iv_cert_type  = gv_certificate_type
    IMPORTING
      ev_application_id = gv_application_id
      ev_status         = gv_status ).

  gv_application_date = sy-datum.

ENDFORM.


FORM validate_data.

  DATA: lo_validation TYPE REF TO zcl_data_validate,
        lv_valid      TYPE abap_bool,
        lv_message    TYPE char150.

  CREATE OBJECT lo_validation.

  lo_validation->validate_application(
    EXPORTING
      iv_citizen_id   = gv_citizen_id
      iv_citizen_name = gv_citizen_name
      iv_dob          = gv_dob
      iv_mobile       = gv_mobile_no
      iv_email        = gv_email
      iv_address      = gv_address
    IMPORTING
      ev_valid   = lv_valid
      ev_message = lv_message ).

  IF lv_valid = abap_true.

    gv_status = 'VALIDATED'.
    MESSAGE lv_message TYPE 'S'.

  ELSE.

    MESSAGE lv_message TYPE 'E'.

  ENDIF.

ENDFORM.


FORM verify_document.

  DATA: lo_document TYPE REF TO zcl_document_verification,
        lv_verified TYPE abap_bool,
        lv_message  TYPE char150.

  CREATE OBJECT lo_document.

  lo_document->verify_document(
    EXPORTING
      iv_application_id = gv_application_id
      iv_document_id    = gv_document_id
      iv_document_type  = gv_document_type
    IMPORTING
      ev_verified = lv_verified
      ev_message  = lv_message ).

  IF lv_verified = abap_true.

    gv_verification_status = 'VERIFIED'.
    gv_verification_remark = lv_message.

    MESSAGE lv_message TYPE 'S'.

  ELSE.

    gv_verification_status = 'REJECTED'.
    gv_verification_remark = lv_message.

    MESSAGE lv_message TYPE 'E'.

  ENDIF.

ENDFORM.


FORM process_application.

  DATA: lo_processor TYPE REF TO zcl_application_processor,
        lv_processed TYPE abap_bool,
        lv_validated TYPE abap_bool,
        lv_verified  TYPE abap_bool,
        lv_message   TYPE char150.

  CREATE OBJECT lo_processor.

  IF gv_status = 'VALIDATED'.
    lv_validated = abap_true.
  ELSE.
    lv_validated = abap_false.
  ENDIF.

  IF gv_verification_status = 'VERIFIED'.
    lv_verified = abap_true.
  ELSE.
    lv_verified = abap_false.
  ENDIF.

  lo_processor->process_application(
    EXPORTING
      iv_application_id    = gv_application_id
      iv_validated         = lv_validated
      iv_document_verified = lv_verified
    IMPORTING
      ev_processed = lv_processed
      ev_message   = lv_message ).

  IF lv_processed = abap_true.

    gv_status = 'PROCESSING'.
    MESSAGE lv_message TYPE 'S'.

  ELSE.

    MESSAGE lv_message TYPE 'E'.

  ENDIF.

ENDFORM.


FORM approve_application.

  DATA: lo_approval TYPE REF TO zcl_approval_manager,
        lv_status   TYPE zegov_e_status,
        lv_message  TYPE char150.

  CREATE OBJECT lo_approval.

  IF gv_status = 'PROCESSING'.

    lo_approval->approve_application(
      EXPORTING
        iv_application_id = gv_application_id
        iv_processed      = abap_true
        iv_approved      = abap_true
      IMPORTING
        ev_status  = lv_status
        ev_message = lv_message ).

  ELSE.

    lv_status = 'REJECTED'.
    lv_message = 'Application is not processed'.

  ENDIF.

  gv_status = lv_status.

  IF lv_status = 'APPROVED'.

    MESSAGE lv_message TYPE 'S'.

  ELSE.

    MESSAGE lv_message TYPE 'E'.

  ENDIF.

ENDFORM.


FORM generate_certificate.

  DATA: lo_generator      TYPE REF TO zcl_certificate_generator,
        lv_certificate_id TYPE zegov_e_certificate_id,
        lv_status         TYPE zegov_e_status,
        lv_message        TYPE char150.

  CREATE OBJECT lo_generator.

  IF gv_status = 'APPROVED'.

    lo_generator->generate_certificate(
      EXPORTING
        iv_application_id = gv_application_id
        iv_approved       = abap_true
      IMPORTING
        ev_certificate_id = lv_certificate_id
        ev_status         = lv_status
        ev_message        = lv_message ).

  ELSE.

    lv_status = 'REJECTED'.
    lv_message = 'Application is not approved'.

  ENDIF.

  gv_certificate_id = lv_certificate_id.
  gv_cert_status    = lv_status.

  IF lv_status = 'CERT_GENERATED'.

    gv_issue_date = sy-datum.
    MESSAGE lv_message TYPE 'S'.

  ELSE.

    MESSAGE lv_message TYPE 'E'.

  ENDIF.

ENDFORM.


FORM verify_certificate.

  DATA: lo_verifier TYPE REF TO zcl_certificate_verifier,
        lv_valid    TYPE abap_bool,
        lv_message  TYPE char150.

  CREATE OBJECT lo_verifier.

  lo_verifier->verify_certificate(
    EXPORTING
      iv_certificate_id = gv_certificate_id
    IMPORTING
      ev_valid   = lv_valid
      ev_message = lv_message ).

  IF lv_valid = abap_true.

    gv_cert_status = 'CERT_GENERATED'.
    MESSAGE lv_message TYPE 'S'.

  ELSE.

    gv_cert_status = 'REJECTED'.
    MESSAGE lv_message TYPE 'E'.

  ENDIF.

ENDFORM.


FORM clear_screen.

  CLEAR: gv_citizen_id,
         gv_citizen_name,
         gv_dob,
         gv_mobile_no,
         gv_email,
         gv_address,
         gv_application_id,
         gv_certificate_type,
         gv_status,
         gv_application_date,
         gv_document_id,
         gv_document_type,
         gv_verification_status,
         gv_verification_remark,
         gv_certificate_id,
         gv_cert_status,
         gv_issue_date.

  LEAVE TO SCREEN 0100.

ENDFORM.
