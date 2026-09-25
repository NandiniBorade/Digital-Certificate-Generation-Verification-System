CLASS zcl_error_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS handle_error
      IMPORTING
        iv_module        TYPE char50
        iv_error_message TYPE char150
      EXPORTING
        ev_message TYPE char150.

ENDCLASS.


CLASS zcl_error_handler IMPLEMENTATION.

  METHOD handle_error.

    IF iv_error_message IS INITIAL.

      ev_message = 'Unknown error occurred'.
      RETURN.

    ENDIF.

    ev_message = |{ iv_module }: { iv_error_message }|.

  ENDMETHOD.

ENDCLASS.
