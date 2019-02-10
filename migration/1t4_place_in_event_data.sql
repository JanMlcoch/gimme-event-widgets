BEGIN TRANSACTION;
INSERT INTO public.place_in_event ("placeId", "eventId", description) VALUES (186, 138, 'Zajímavé město poblíž');
INSERT INTO public.place_in_event ("placeId", "eventId", description) VALUES (134, 193, 'Nejbližší velký obchod');
INSERT INTO public.place_in_event ("placeId", "eventId", description) VALUES (110, 162, 'Další promítání');
INSERT INTO public.place_in_event ("placeId", "eventId", description) VALUES (190, 162, 'Další promítání');
INSERT INTO public.place_in_event ("placeId", "eventId", description) VALUES (100, 162, 'Další promítání');
COMMIT TRANSACTION;