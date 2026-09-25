CLASS zcl_data_validate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS validate_application
      IMPORTING
        iv_citizen_id   TYPE zegov_e_citizen_id
        iv_citizen_name TYPE char60
        iv_dob          TYPE dats
        iv_mobile       TYPE char10
        iv_email        TYPE char100
        iv_address      TYPE char150
      EXPORTING
        ev_valid   TYPE abap_bool
        ev_message TYPE char150.

ENDCLASS.


CLASS zcl_data_validate IMPLEMENTATION.

  METHOD validate_application.

    ev_valid   = abap_true.
    ev_message = 'Data is valid'.

    IF iv_citizen_id IS INITIAL.
      ev_valid   = abap_false.
      ev_message = 'Citizen ID is mandatory'.
      RETURN.
    ENDIF.

    IF iv_citizen_name IS INITIAL.
      ev_valid   = abap_false.
      ev_message = 'Citizen Name is mandatory'.
      RETURN.
    ENDIF.

    IF iv_dob IS INITIAL.
      ev_valid   = abap_false.
      ev_message = 'Date of Birth is mandatory'.
      RETURN.
    ENDIF.

    IF iv_mobile IS INITIAL.
      ev_valid   = abap_false.
      ev_message = 'Mobile Number is mandatory'.
      RETURN.
    ENDIF.

    IF iv_email IS INITIAL.
      ev_valid   = abap_false.
      ev_message = 'Email is mandatory'.
      RETURN.
    ENDIF.

    IF iv_address IS INITIAL.
      ev_valid   = abap_false.
      ev_message = 'Address is mandatory'.
      RETURN.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
