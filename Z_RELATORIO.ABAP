REPORT Z_EXERCICIO3_INTERMEDIARIO.

* DECLARANDO A TABELA QUE IREI USAR
TABLES: ZT0005.

* CRIANDO TIPO COM OS CAMPOS DA TABELA ZT0005
TYPES:  BEGIN OF TY_DADOS,
  MATER TYPE ZT0005-MATER,
  DENOM TYPE ZT0005-DENOM,
  TPMAT TYPE ZT0005-TPMAT,
  BRGEW TYPE ZT0005-BRGEW,
  NTGEW TYPE ZT0005-NTGEW,
  GEWEI TYPE ZT0005-GEWEI,
  END OF TY_DADOS.

* CRIANDO TABELA INTERNA
DATA: T_MATER    TYPE TABLE OF TY_DADOS,
      T_HEADER   TYPE SLIS_T_LISTHEADER,
      T_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.

* CRIANDO WORK AREA
DATA: W_MATER    TYPE TY_DADOS,
      W_LAYOUT   TYPE SLIS_LAYOUT_ALV,
      W_HEADER   TYPE SLIS_LISTHEADER,
      W_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

* INICIANDO A SELECAO DE DADOS
  START-OF-SELECTION.
  SELECT MATER, DENOM, TPMAT, BRGEW, NTGEW, GEWEI
    FROM ZT0005
    INTO TABLE @T_MATER.
    END-OF-SELECTION.

* CRIANDO PERFOMS PARA ROTINA DE DADOS
PERFORM F_LAYOUT.
PERFORM F_FIELDCAT.
PERFORM F_TOP_OF_PAGE.
PERFORM F_DISPLAY.
*&---------------------------------------------------------------------*
*& Form F_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_layout .

  W_LAYOUT-ZEBRA = 'X'.
  W_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_fieldcat .

CLEAR W_FIELDCAT.
W_FIELDCAT-FIELDNAME = 'MATER'.
W_FIELDCAT-SELTEXT_M = 'MATERIAL'.
W_FIELDCAT-COL_POS   = 1.
APPEND W_FIELDCAT TO T_FIELDCAT.

CLEAR W_FIELDCAT.
W_FIELDCAT-FIELDNAME = 'DENOM'.
W_FIELDCAT-SELTEXT_M = 'DENOMINACAO'.
W_FIELDCAT-COL_POS   = 2.
APPEND W_FIELDCAT TO T_FIELDCAT.

CLEAR W_FIELDCAT.
W_FIELDCAT-FIELDNAME = 'TPMAT'.
W_FIELDCAT-SELTEXT_M = 'TIPO DE MATERIAL'.
W_FIELDCAT-COL_POS   = 3.
APPEND W_FIELDCAT TO T_FIELDCAT.

CLEAR W_FIELDCAT.
W_FIELDCAT-FIELDNAME = 'BRGEW'.
W_FIELDCAT-SELTEXT_M = 'PESO BRUTO'.
W_FIELDCAT-COL_POS   = 4.
APPEND W_FIELDCAT TO T_FIELDCAT.

CLEAR W_FIELDCAT.
W_FIELDCAT-FIELDNAME = 'NTGEW'.
W_FIELDCAT-SELTEXT_M = 'PESO LIQUIDO'.
W_FIELDCAT-COL_POS   = 5.
APPEND W_FIELDCAT TO T_FIELDCAT.

CLEAR W_FIELDCAT.
W_FIELDCAT-FIELDNAME = 'GEWEI'.
W_FIELDCAT-SELTEXT_M = 'UNIDADE DE PESO'.
W_FIELDCAT-COL_POS   = 6.
APPEND W_FIELDCAT TO T_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_top_of_page .

* CRIANDO VARIAVEL LOCAL PARA O CABECALHO
 DATA: VL_DATA TYPE SY-DATUM,
       VL_HORA TYPE SY-UZEIT,
       VL_USER TYPE SY-UNAME.

WRITE SY-DATUM TO VL_DATA DD/MM/YYYY.
WRITE SY-UNAME TO VL_USER.


* PREENCHENDO CABECALHO
CLEAR W_HEADER.
  W_HEADER-TYP  = 'H'.
  W_HEADER-INFO = 'RELATORIO DE MATERIAIS'.
  APPEND W_HEADER TO T_HEADER.

CLEAR W_HEADER.
  W_HEADER-TYP  = 'S'.
  W_HEADER-KEY  = 'DATA: '.
  W_HEADER-INFO = VL_DATA.
  APPEND W_HEADER TO T_HEADER.

CLEAR W_HEADER.
  W_HEADER-TYP  = 'S'.
  W_HEADER-KEY = 'USUARIO: '.
  W_HEADER-INFO = VL_USER.
  APPEND W_HEADER TO T_HEADER.

* CHAMANDO AS VARIAVEIS DECLARADAS
*  VL_DATA = SY-DATUM.
*  VL_HORA = SY-UZEIT.
*  VL_USER = SY-UNAME.

*WRITE:/ 'DATA: ' , SY-DATUM,
*      / 'HORA: ' , SY-UZEIT,
*      / 'USER: ' , SY-UNAME.
*APPEND W_HEADER TO T_HEADER.

* FUNCAO PARA EXIBIR O CABECALHO
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary       = T_HEADER.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_display .

* FUNCAO PARA EXIBIR O RELATORIO ALV PARA O USUARIO

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
     I_CALLBACK_TOP_OF_PAGE            = 'F_TOP_OF_PAGE'
     IS_LAYOUT                         = W_LAYOUT
     IT_FIELDCAT                       = T_FIELDCAT
     I_DEFAULT                         = 'X'
     I_SAVE                            = 'X'
    TABLES
      t_outtab                          = T_MATER.
  IF sy-subrc <> 0.
MESSAGE 'ERRO AO EXIBIR O RELATORIO ALV' TYPE 'I'.
  ENDIF.
            .


ENDFORM.