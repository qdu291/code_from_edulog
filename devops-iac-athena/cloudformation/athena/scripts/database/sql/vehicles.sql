DELETE FROM public.vehicle;

INSERT INTO public.vehicle(
	id, surrogate_key, vin, vehicle_name, capacity, description, contractor, gps_id, depot_id, manufacturer, model, year, year_beginning, year_termination, comments, user_id, time_changed, create_date)
	--1	de08e5e6-c522-4cb2-bc79-42f32751b920	180588	first	30	the first vehcle	someone	\N	\N	Ford	theBest	1988	2019	\N	creation of first vehicle	TEST	2019-06-25 14:00:19.001529+00	2019-06-25 14:00:19.001432+00
	VALUES (1, 'de08e5e6-c522-4cb2-bc79-42f32751b920', 'GEFT1705198800000', 'First', 30, 'The first vehicle.', 'Someone', null, null, 'Ford', 'theBest', 1988, 2019, null, 'creation of first vehicle', 'TEST', current_timestamp, current_timestamp);
	
INSERT INTO public.vehicle(
	id, surrogate_key, vin, vehicle_name, capacity, description, contractor, gps_id, depot_id, manufacturer, model, year, year_beginning, year_termination, comments, user_id, time_changed, create_date)
	--2	647f31ef-6fa7-4e6e-a64a-ea1ba2e2a3fa	190588	second	30	the second vehcle	someone	\N	\N	Ford	theBest	1988	2019	\N	creation of second vehicle	TEST	2019-06-25 14:00:40.755557+00	2019-06-25 14:00:40.755415+00
	VALUES (2, '647f31ef-6fa7-4e6e-a64a-ea1ba2e2a3fa', 'GEFT1705198800001', 'Second', 30, 'A second vehicle.', 'Another', null, null, 'Ford', 'theBest', 1988, 2019, null, 'creation of second vehicle', 'TEST', current_timestamp, current_timestamp);
	
INSERT INTO public.vehicle(
	id, surrogate_key, vin, vehicle_name, capacity, description, contractor, gps_id, depot_id, manufacturer, model, year, year_beginning, year_termination, comments, user_id, time_changed, create_date)
--3	6ddc606a-98b7-41b1-9f23-891cc1b5d699	170588	toDel	30	the vehcle toDelete	someone	\N	\N	Ford	theBest	1988	2019	\N	creation of vehicle to delete	TEST	2019-06-25 13:59:41.739326+00	2019-06-25 13:59:41.739326+00
VALUES (3, '6ddc606a-98b7-41b1-9f23-891cc1b5d699', 'GEFT1705198800002', 'Third', 30, 'Vehicle #3', 'Bob Wire', null, null, 'Ford', 'theBest', 1988, 2019, null, 'creation of vehicle to delete', 'TEST', current_timestamp, current_timestamp);

ALTER SEQUENCE public.vehicle_id_seq RESTART WITH 4;
