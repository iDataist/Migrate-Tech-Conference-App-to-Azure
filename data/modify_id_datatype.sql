CREATE SEQUENCE new_serial START 6 OWNED BY attendee.id;

ALTER TABLE attendee ALTER COLUMN id SET DEFAULT nextval('new_serial');

select * from attendee

CREATE SEQUENCE id_serial START 6 OWNED BY notification.id;

ALTER TABLE notification ALTER COLUMN id SET DEFAULT nextval('id_serial');

select * from notification