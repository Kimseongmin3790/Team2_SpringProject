--------------------------------------------------------
--  파일이 생성됨 - 목요일-1월-22-2026   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger TRG_CHAT_MESSAGE_BI
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "ADMIN"."TRG_CHAT_MESSAGE_BI" 
BEFORE INSERT ON ADMIN.P_CHAT_MESSAGE
FOR EACH ROW
BEGIN
  IF :NEW.MESSAGE_ID IS NULL THEN
    SELECT ADMIN.SEQ_CHAT_MESSAGE_ID.NEXTVAL INTO :NEW.MESSAGE_ID FROM DUAL;
  END IF;

  IF :NEW.CDATETIME IS NULL THEN :NEW.CDATETIME := SYSDATE; END IF;
END;

/
ALTER TRIGGER "ADMIN"."TRG_CHAT_MESSAGE_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_CHAT_ROOM_BI
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "ADMIN"."TRG_CHAT_ROOM_BI" 
BEFORE INSERT ON ADMIN.P_CHAT_ROOM
FOR EACH ROW
BEGIN
  IF :NEW.ROOM_ID IS NULL THEN
    SELECT ADMIN.SEQ_CHAT_ROOM_ID.NEXTVAL INTO :NEW.ROOM_ID FROM DUAL;
  END IF;

  IF :NEW.CDATETIME IS NULL THEN :NEW.CDATETIME := SYSDATE; END IF;
  :NEW.UDATETIME := SYSDATE;
END;

/
ALTER TRIGGER "ADMIN"."TRG_CHAT_ROOM_BI" ENABLE;
