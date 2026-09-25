CLASS zcl_citizen_registration DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS register_citizen
      IMPORTING
        iv_citizen_id   TYPE zegov_e_citizen_id
        iv_citizen_name TYPE char60
        iv_dob          TYPE dats
        iv_mobile       TYPE char10
        iv_email        TYPE char100
        iv_address      TYPE char150.

ENDCLASS.


CLASS zcl_citizen_registration IMPLEMENTATION.

  METHOD register_citizen.

    DATA: ls_citizen TYPE zgov_citizen_app.

    ls_citizen-citizen_id   = iv_citizen_id.
    ls_citizen-citizen_name = iv_citizen_name.
    ls_citizen-dob          = iv_dob.
    ls_citizen-mobile_no    = iv_mobile.
    ls_citizen-email        = iv_email.
    ls_citizen-address      = iv_address.

    ls_citizen-status     = 'SUBMITTED'.
    ls_citizen-created_on = sy-datum.
    ls_citizen-created_by = sy-uname.

    SELECT SINGLE citizen_id
      FROM zgov_citizen_app
      INTO @DATA(lv_citizen_id)
      WHERE citizen_id = @iv_citizen_id.

    IF sy-subrc = 0.
      MESSAGE 'Citizen already registered' TYPE 'E'.
    ENDIF.

    INSERT zgov_citizen_app FROM ls_citizen.

    IF sy-subrc = 0.
      COMMIT WORK.
      MESSAGE 'Citizen registered successfully' TYPE 'S'.
    ELSE.
      ROLLBACK WORK.
      MESSAGE 'Citizen registration failed' TYPE 'E'.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
