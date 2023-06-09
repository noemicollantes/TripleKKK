toc.dat                                                                                             0000600 0004000 0002000 00000074655 14440514412 0014457 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP                           {         	   TripleKKK    15.2    15.2 W    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         �           1262    16397 	   TripleKKK    DATABASE     �   CREATE DATABASE "TripleKKK" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Colombia.1252';
    DROP DATABASE "TripleKKK";
                postgres    false                     2615    25103    triplek    SCHEMA        CREATE SCHEMA triplek;
    DROP SCHEMA triplek;
                postgres    false         �            1255    33584    audi_piece_func()    FUNCTION     �  CREATE FUNCTION triplek.audi_piece_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	INSERT INTO TRIPLEK.AUDI_PIECE (ID_AUDI_PIECE,ID_PIECE,ID_SCHOOL_PIECE,ID_UNIFORM,ID_SCHOOL_UNIFORM,NAME_PIECE,ID_SIZE,
								   GENDER_PIECE,TYPE_PIECE,AMOUNT_PIECE,PRICE_PIECE)
	VALUES (DEFAULT,OLD.ID_PIECE,OLD.ID_SCHOOL_PIECE,OLD.ID_UNIFORM,OLD.ID_SCHOOL_UNIFORM,OLD.NAME_PIECE,OLD.ID_SIZE,
								   OLD.GENDER_PIECE,OLD.TYPE_PIECE,OLD.AMOUNT_PIECE,OLD.PRICE_PIECE);
RETURN NEW;								  
END;
$$;
 )   DROP FUNCTION triplek.audi_piece_func();
       triplek          postgres    false    5         �            1255    33560    total_uniform()    FUNCTION     9  CREATE FUNCTION triplek.total_uniform() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 CP INTEGER; -- Variable para saber la cantidad de piezas que contiene el uniforme
 SBT DECIMAL; -- Variable para tener el subtotal del precio del uniforme
 TU DECIMAL; -- Variable para tener el total del uniforme
 NP INTEGER; -- NUMERO DE PIEZAS CON LAS QUE SE CONFORMA UN UNIFORME
 DESCU DECIMAL; -- Variable para almacenar el descuento 
BEGIN
	IF (TG_OP = 'INSERT') THEN -- Cuando se realizo una insercion
		IF (NEW.ID_UNIFORM <> '0' AND NEW.ID_SCHOOL_UNIFORM != 0 ) THEN
			SELECT COUNT(*),SUM(PIE.PRICE_PIECE) INTO CP,SBT FROM TRIPLEK.UNIFORM UNI
			INNER JOIN TRIPLEK.PIECE PIE
			ON (UNI.ID_UNIFORM = PIE.ID_UNIFORM) 
			AND (UNI.ID_SCHOOL = PIE.ID_SCHOOL_UNIFORM);
			-- Obtener el numero de piezas y el descuento de un uniforme
			SELECT NUM_PIECE,DESCONT_UNIFORM INTO NP,DESCU FROM TRIPLEK.UNIFORM
			WHERE ID_SCHOOL = NEW.ID_SCHOOL_UNIFORM
			AND ID_UNIFORM = NEW.ID_UNIFORM;		
			IF (CP =  NP) THEN
				TU := SBT - DESCU; --Aplicar el descuento
			ELSE
				TU := SBT; --Precio cuando no se aplica el descuento 
			END IF;
			UPDATE TRIPLEK.UNIFORM SET SUB_TOTAL_UNIFORM = SBT, TOTAL_UNIFORM = TU
			WHERE ID_SCHOOL = NEW.ID_SCHOOL_UNIFORM
			AND ID_UNIFORM = NEW.ID_UNIFORM;
			RETURN NEW;				
		END IF;		
	ELSIF (TG_OP = 'DELETE') THEN -- Cuando se realiza una eliminacion 
		IF (OLD.ID_UNIFORM <> '0' AND OLD.ID_SCHOOL_UNIFORM != 0 ) THEN
			SELECT COUNT(*),SUM(PIE.PRICE_PIECE) INTO CP,SBT FROM TRIPLEK.UNIFORM UNI
			INNER JOIN TRIPLEK.PIECE PIE
			ON (UNI.ID_UNIFORM = PIE.ID_UNIFORM) 
			AND (UNI.ID_SCHOOL = PIE.ID_SCHOOL_UNIFORM);
			-- Obtener el numero de piezas y el descuento de un uniforme
			SELECT NUM_PIECE,DESCONT_UNIFORM INTO NP,DESCU FROM TRIPLEK.UNIFORM
			WHERE ID_SCHOOL = OLD.ID_SCHOOL_UNIFORM
			AND ID_UNIFORM = OLD.ID_UNIFORM;		
			CP := CP + 1;
			TU := SBT;
			UPDATE TRIPLEK.UNIFORM SET SUB_TOTAL_UNIFORM = SBT, TOTAL_UNIFORM = TU
			WHERE ID_SCHOOL = OLD.ID_SCHOOL_UNIFORM
			AND ID_UNIFORM = OLD.ID_UNIFORM;
			RETURN NEW;
		END IF;		
	END IF;
RETURN NEW;		
END;
$$;
 '   DROP FUNCTION triplek.total_uniform();
       triplek          postgres    false    5         �            1259    33607 
   audi_login    TABLE     �  CREATE TABLE triplek.audi_login (
    id_audi_login integer NOT NULL,
    id_document_type character varying(5),
    number_document character varying(12) NOT NULL,
    id_usser integer,
    name_person character varying(30),
    last_name_person character varying(30),
    phone_person character varying(10),
    email_person character varying(50),
    usser_name character varying(30),
    usser_password character varying(50),
    date_audi_login timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE triplek.audi_login;
       triplek         heap    postgres    false    5         �            1259    33606    audi_login_id_audi_login_seq    SEQUENCE     �   CREATE SEQUENCE triplek.audi_login_id_audi_login_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE triplek.audi_login_id_audi_login_seq;
       triplek          postgres    false    232    5         �           0    0    audi_login_id_audi_login_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE triplek.audi_login_id_audi_login_seq OWNED BY triplek.audi_login.id_audi_login;
          triplek          postgres    false    231         �            1259    33589 
   audi_piece    TABLE     �  CREATE TABLE triplek.audi_piece (
    id_audi_piece integer NOT NULL,
    id_piece character varying(5) NOT NULL,
    id_school_piece integer NOT NULL,
    id_uniform character varying(5),
    id_school_uniform integer,
    name_piece character varying(100),
    id_size character varying(4),
    gender_piece character(1),
    type_piece character(1),
    amount_piece integer,
    price_piece numeric,
    date_audi_piece timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE triplek.audi_piece;
       triplek         heap    postgres    false    5         �            1259    33588    audi_piece_id_audi_piece_seq    SEQUENCE     �   CREATE SEQUENCE triplek.audi_piece_id_audi_piece_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE triplek.audi_piece_id_audi_piece_seq;
       triplek          postgres    false    230    5         �           0    0    audi_piece_id_audi_piece_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE triplek.audi_piece_id_audi_piece_seq OWNED BY triplek.audi_piece.id_audi_piece;
          triplek          postgres    false    229         �            1259    33525    document_type    TABLE     �   CREATE TABLE triplek.document_type (
    id_document_type character varying(5) NOT NULL,
    name_document_type character varying(30),
    CONSTRAINT nn_name_document_type CHECK ((name_document_type IS NOT NULL))
);
 "   DROP TABLE triplek.document_type;
       triplek         heap    postgres    false    5         �            1259    25180    person    TABLE     �  CREATE TABLE triplek.person (
    number_document character varying(12) NOT NULL,
    id_usser integer,
    name_person character varying(30),
    last_name_person character varying(30),
    phone_person character varying(10),
    email_person character varying(50),
    id_document_type character varying(5),
    CONSTRAINT nn_last_name_person CHECK ((last_name_person IS NOT NULL)),
    CONSTRAINT nn_name_person CHECK ((name_person IS NOT NULL))
);
    DROP TABLE triplek.person;
       triplek         heap    postgres    false    5         �            1259    33490 	   seq_piece    SEQUENCE     t   CREATE SEQUENCE triplek.seq_piece
    START WITH 20
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE triplek.seq_piece;
       triplek          postgres    false    5         �            1259    33491    piece    TABLE       CREATE TABLE triplek.piece (
    id_piece character varying(5) DEFAULT to_char(nextval('triplek.seq_piece'::regclass), 'FM00'::text) NOT NULL,
    id_school_piece integer NOT NULL,
    id_uniform character varying(5),
    name_piece character varying(100),
    id_size character varying(4),
    gender_piece character(1),
    type_piece_use character(1),
    amount_piece integer,
    price_piece numeric,
    type_piece integer,
    id_school_uniform integer,
    CONSTRAINT ck_amount_piece CHECK ((amount_piece >= 0)),
    CONSTRAINT ck_gender_piece CHECK ((gender_piece = ANY (ARRAY['M'::bpchar, 'F'::bpchar]))),
    CONSTRAINT ck_name_piece CHECK ((name_piece IS NOT NULL)),
    CONSTRAINT ck_type_piece CHECK ((type_piece_use = ANY (ARRAY['D'::bpchar, 'F'::bpchar]))),
    CONSTRAINT nn_gender_piece CHECK ((gender_piece IS NOT NULL)),
    CONSTRAINT nn_id_size CHECK ((id_size IS NOT NULL)),
    CONSTRAINT nn_name_piece CHECK ((name_piece IS NOT NULL)),
    CONSTRAINT nn_type_piece CHECK ((type_piece_use IS NOT NULL))
);
    DROP TABLE triplek.piece;
       triplek         heap    postgres    false    224    5         �            1259    25147    role    TABLE     �   CREATE TABLE triplek.role (
    id_role integer NOT NULL,
    name_role character varying(30),
    CONSTRAINT nn_name_role CHECK ((name_role IS NOT NULL))
);
    DROP TABLE triplek.role;
       triplek         heap    postgres    false    5         �            1259    25146    role_id_role_seq    SEQUENCE     �   CREATE SEQUENCE triplek.role_id_role_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE triplek.role_id_role_seq;
       triplek          postgres    false    218    5         �           0    0    role_id_role_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE triplek.role_id_role_seq OWNED BY triplek.role.id_role;
          triplek          postgres    false    217         �            1259    25127    school    TABLE     �   CREATE TABLE triplek.school (
    id_school integer NOT NULL,
    name_school character varying(100),
    CONSTRAINT nn_name_school CHECK ((name_school IS NOT NULL))
);
    DROP TABLE triplek.school;
       triplek         heap    postgres    false    5         �            1259    25126    school_id_school_seq    SEQUENCE     �   CREATE SEQUENCE triplek.school_id_school_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE triplek.school_id_school_seq;
       triplek          postgres    false    5    216         �           0    0    school_id_school_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE triplek.school_id_school_seq OWNED BY triplek.school.id_school;
          triplek          postgres    false    215         �            1259    33389    seq_uniform    SEQUENCE     v   CREATE SEQUENCE triplek.seq_uniform
    START WITH 20
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE triplek.seq_uniform;
       triplek          postgres    false    5         �            1259    25112    size    TABLE     �   CREATE TABLE triplek.size (
    id_size character varying(4) NOT NULL,
    name_size character varying(20),
    CONSTRAINT nn_name_size CHECK ((name_size IS NOT NULL))
);
    DROP TABLE triplek.size;
       triplek         heap    postgres    false    5         �            1259    33544 
   type_piece    TABLE     �   CREATE TABLE triplek.type_piece (
    id_type_piece integer NOT NULL,
    name_type_piece character varying(20),
    CONSTRAINT nn_name_type_piece CHECK ((name_type_piece IS NOT NULL))
);
    DROP TABLE triplek.type_piece;
       triplek         heap    postgres    false    5         �            1259    33543    type_piece_id_type_piece_seq    SEQUENCE     �   CREATE SEQUENCE triplek.type_piece_id_type_piece_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE triplek.type_piece_id_type_piece_seq;
       triplek          postgres    false    5    228         �           0    0    type_piece_id_type_piece_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE triplek.type_piece_id_type_piece_seq OWNED BY triplek.type_piece.id_type_piece;
          triplek          postgres    false    227         �            1259    33466    uniform    TABLE     x  CREATE TABLE triplek.uniform (
    id_uniform character varying(5) DEFAULT to_char(nextval('triplek.seq_uniform'::regclass), 'FM00'::text) NOT NULL,
    name_uniform character varying(100),
    id_school integer NOT NULL,
    id_size character varying(4),
    gender_uniform character(1),
    type_uniform character(1),
    num_piece integer,
    sub_total_uniform numeric,
    descont_uniform numeric,
    total_uniform numeric,
    CONSTRAINT ck_gender_uniform CHECK ((gender_uniform = ANY (ARRAY['M'::bpchar, 'F'::bpchar]))),
    CONSTRAINT ck_name_uniform CHECK ((name_uniform IS NOT NULL)),
    CONSTRAINT ck_type_uniform CHECK ((type_uniform = ANY (ARRAY['D'::bpchar, 'F'::bpchar]))),
    CONSTRAINT nn_gender_uniform CHECK ((gender_uniform IS NOT NULL)),
    CONSTRAINT nn_id_size CHECK ((id_size IS NOT NULL)),
    CONSTRAINT nn_type_uniform CHECK ((type_uniform IS NOT NULL))
);
    DROP TABLE triplek.uniform;
       triplek         heap    postgres    false    222    5         �            1259    25163    usser    TABLE     �  CREATE TABLE triplek.usser (
    id_usser integer NOT NULL,
    id_role integer,
    state_usser character(1),
    usser_name character varying(30),
    usser_password character varying(50),
    CONSTRAINT ck_state_usser CHECK ((state_usser = ANY (ARRAY['A'::bpchar, 'I'::bpchar]))),
    CONSTRAINT nn_state_usser CHECK ((state_usser IS NOT NULL)),
    CONSTRAINT nn_usser_name CHECK ((usser_name IS NOT NULL)),
    CONSTRAINT nn_usser_password CHECK ((usser_password IS NOT NULL))
);
    DROP TABLE triplek.usser;
       triplek         heap    postgres    false    5         �            1259    25162    usser_id_usser_seq    SEQUENCE     �   CREATE SEQUENCE triplek.usser_id_usser_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE triplek.usser_id_usser_seq;
       triplek          postgres    false    220    5         �           0    0    usser_id_usser_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE triplek.usser_id_usser_seq OWNED BY triplek.usser.id_usser;
          triplek          postgres    false    219         �           2604    33610    audi_login id_audi_login    DEFAULT     �   ALTER TABLE ONLY triplek.audi_login ALTER COLUMN id_audi_login SET DEFAULT nextval('triplek.audi_login_id_audi_login_seq'::regclass);
 H   ALTER TABLE triplek.audi_login ALTER COLUMN id_audi_login DROP DEFAULT;
       triplek          postgres    false    231    232    232         �           2604    33592    audi_piece id_audi_piece    DEFAULT     �   ALTER TABLE ONLY triplek.audi_piece ALTER COLUMN id_audi_piece SET DEFAULT nextval('triplek.audi_piece_id_audi_piece_seq'::regclass);
 H   ALTER TABLE triplek.audi_piece ALTER COLUMN id_audi_piece DROP DEFAULT;
       triplek          postgres    false    230    229    230         �           2604    25150    role id_role    DEFAULT     n   ALTER TABLE ONLY triplek.role ALTER COLUMN id_role SET DEFAULT nextval('triplek.role_id_role_seq'::regclass);
 <   ALTER TABLE triplek.role ALTER COLUMN id_role DROP DEFAULT;
       triplek          postgres    false    217    218    218         �           2604    25130    school id_school    DEFAULT     v   ALTER TABLE ONLY triplek.school ALTER COLUMN id_school SET DEFAULT nextval('triplek.school_id_school_seq'::regclass);
 @   ALTER TABLE triplek.school ALTER COLUMN id_school DROP DEFAULT;
       triplek          postgres    false    216    215    216         �           2604    33547    type_piece id_type_piece    DEFAULT     �   ALTER TABLE ONLY triplek.type_piece ALTER COLUMN id_type_piece SET DEFAULT nextval('triplek.type_piece_id_type_piece_seq'::regclass);
 H   ALTER TABLE triplek.type_piece ALTER COLUMN id_type_piece DROP DEFAULT;
       triplek          postgres    false    227    228    228         �           2604    25166    usser id_usser    DEFAULT     r   ALTER TABLE ONLY triplek.usser ALTER COLUMN id_usser SET DEFAULT nextval('triplek.usser_id_usser_seq'::regclass);
 >   ALTER TABLE triplek.usser ALTER COLUMN id_usser DROP DEFAULT;
       triplek          postgres    false    219    220    220         �          0    33607 
   audi_login 
   TABLE DATA           �   COPY triplek.audi_login (id_audi_login, id_document_type, number_document, id_usser, name_person, last_name_person, phone_person, email_person, usser_name, usser_password, date_audi_login) FROM stdin;
    triplek          postgres    false    232       3467.dat �          0    33589 
   audi_piece 
   TABLE DATA           �   COPY triplek.audi_piece (id_audi_piece, id_piece, id_school_piece, id_uniform, id_school_uniform, name_piece, id_size, gender_piece, type_piece, amount_piece, price_piece, date_audi_piece) FROM stdin;
    triplek          postgres    false    230       3465.dat �          0    33525    document_type 
   TABLE DATA           N   COPY triplek.document_type (id_document_type, name_document_type) FROM stdin;
    triplek          postgres    false    226       3461.dat �          0    25180    person 
   TABLE DATA           �   COPY triplek.person (number_document, id_usser, name_person, last_name_person, phone_person, email_person, id_document_type) FROM stdin;
    triplek          postgres    false    221       3456.dat �          0    33491    piece 
   TABLE DATA           �   COPY triplek.piece (id_piece, id_school_piece, id_uniform, name_piece, id_size, gender_piece, type_piece_use, amount_piece, price_piece, type_piece, id_school_uniform) FROM stdin;
    triplek          postgres    false    225       3460.dat }          0    25147    role 
   TABLE DATA           3   COPY triplek.role (id_role, name_role) FROM stdin;
    triplek          postgres    false    218       3453.dat {          0    25127    school 
   TABLE DATA           9   COPY triplek.school (id_school, name_school) FROM stdin;
    triplek          postgres    false    216       3451.dat y          0    25112    size 
   TABLE DATA           3   COPY triplek.size (id_size, name_size) FROM stdin;
    triplek          postgres    false    214       3449.dat �          0    33544 
   type_piece 
   TABLE DATA           E   COPY triplek.type_piece (id_type_piece, name_type_piece) FROM stdin;
    triplek          postgres    false    228       3463.dat �          0    33466    uniform 
   TABLE DATA           �   COPY triplek.uniform (id_uniform, name_uniform, id_school, id_size, gender_uniform, type_uniform, num_piece, sub_total_uniform, descont_uniform, total_uniform) FROM stdin;
    triplek          postgres    false    223       3458.dat           0    25163    usser 
   TABLE DATA           \   COPY triplek.usser (id_usser, id_role, state_usser, usser_name, usser_password) FROM stdin;
    triplek          postgres    false    220       3455.dat �           0    0    audi_login_id_audi_login_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('triplek.audi_login_id_audi_login_seq', 7, true);
          triplek          postgres    false    231         �           0    0    audi_piece_id_audi_piece_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('triplek.audi_piece_id_audi_piece_seq', 5, true);
          triplek          postgres    false    229         �           0    0    role_id_role_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('triplek.role_id_role_seq', 2, true);
          triplek          postgres    false    217         �           0    0    school_id_school_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('triplek.school_id_school_seq', 5, true);
          triplek          postgres    false    215         �           0    0 	   seq_piece    SEQUENCE SET     9   SELECT pg_catalog.setval('triplek.seq_piece', 48, true);
          triplek          postgres    false    224         �           0    0    seq_uniform    SEQUENCE SET     ;   SELECT pg_catalog.setval('triplek.seq_uniform', 28, true);
          triplek          postgres    false    222         �           0    0    type_piece_id_type_piece_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('triplek.type_piece_id_type_piece_seq', 7, true);
          triplek          postgres    false    227         �           0    0    usser_id_usser_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('triplek.usser_id_usser_seq', 2, true);
          triplek          postgres    false    219         �           2606    33597    audi_piece audi_piece_pkey 
   CONSTRAINT        ALTER TABLE ONLY triplek.audi_piece
    ADD CONSTRAINT audi_piece_pkey PRIMARY KEY (id_audi_piece, id_piece, id_school_piece);
 E   ALTER TABLE ONLY triplek.audi_piece DROP CONSTRAINT audi_piece_pkey;
       triplek            postgres    false    230    230    230         �           2606    33613    audi_login pk_audi_login 
   CONSTRAINT     s   ALTER TABLE ONLY triplek.audi_login
    ADD CONSTRAINT pk_audi_login PRIMARY KEY (id_audi_login, number_document);
 C   ALTER TABLE ONLY triplek.audi_login DROP CONSTRAINT pk_audi_login;
       triplek            postgres    false    232    232         �           2606    33530    document_type pk_document_type 
   CONSTRAINT     k   ALTER TABLE ONLY triplek.document_type
    ADD CONSTRAINT pk_document_type PRIMARY KEY (id_document_type);
 I   ALTER TABLE ONLY triplek.document_type DROP CONSTRAINT pk_document_type;
       triplek            postgres    false    226         �           2606    25187    person pk_person 
   CONSTRAINT     \   ALTER TABLE ONLY triplek.person
    ADD CONSTRAINT pk_person PRIMARY KEY (number_document);
 ;   ALTER TABLE ONLY triplek.person DROP CONSTRAINT pk_person;
       triplek            postgres    false    221         �           2606    33504    piece pk_piece 
   CONSTRAINT     d   ALTER TABLE ONLY triplek.piece
    ADD CONSTRAINT pk_piece PRIMARY KEY (id_school_piece, id_piece);
 9   ALTER TABLE ONLY triplek.piece DROP CONSTRAINT pk_piece;
       triplek            postgres    false    225    225         �           2606    25153    role pk_role 
   CONSTRAINT     P   ALTER TABLE ONLY triplek.role
    ADD CONSTRAINT pk_role PRIMARY KEY (id_role);
 7   ALTER TABLE ONLY triplek.role DROP CONSTRAINT pk_role;
       triplek            postgres    false    218         �           2606    25133    school pk_school 
   CONSTRAINT     V   ALTER TABLE ONLY triplek.school
    ADD CONSTRAINT pk_school PRIMARY KEY (id_school);
 ;   ALTER TABLE ONLY triplek.school DROP CONSTRAINT pk_school;
       triplek            postgres    false    216         �           2606    25117    size pk_size 
   CONSTRAINT     P   ALTER TABLE ONLY triplek.size
    ADD CONSTRAINT pk_size PRIMARY KEY (id_size);
 7   ALTER TABLE ONLY triplek.size DROP CONSTRAINT pk_size;
       triplek            postgres    false    214         �           2606    33550    type_piece pk_type_piece 
   CONSTRAINT     b   ALTER TABLE ONLY triplek.type_piece
    ADD CONSTRAINT pk_type_piece PRIMARY KEY (id_type_piece);
 C   ALTER TABLE ONLY triplek.type_piece DROP CONSTRAINT pk_type_piece;
       triplek            postgres    false    228         �           2606    33477    uniform pk_uniform 
   CONSTRAINT     d   ALTER TABLE ONLY triplek.uniform
    ADD CONSTRAINT pk_uniform PRIMARY KEY (id_school, id_uniform);
 =   ALTER TABLE ONLY triplek.uniform DROP CONSTRAINT pk_uniform;
       triplek            postgres    false    223    223         �           2606    25172    usser pk_usser 
   CONSTRAINT     S   ALTER TABLE ONLY triplek.usser
    ADD CONSTRAINT pk_usser PRIMARY KEY (id_usser);
 9   ALTER TABLE ONLY triplek.usser DROP CONSTRAINT pk_usser;
       triplek            postgres    false    220         �           2606    25189    person uq_id_usser 
   CONSTRAINT     R   ALTER TABLE ONLY triplek.person
    ADD CONSTRAINT uq_id_usser UNIQUE (id_usser);
 =   ALTER TABLE ONLY triplek.person DROP CONSTRAINT uq_id_usser;
       triplek            postgres    false    221         �           2606    33532 #   document_type uq_name_document_type 
   CONSTRAINT     m   ALTER TABLE ONLY triplek.document_type
    ADD CONSTRAINT uq_name_document_type UNIQUE (name_document_type);
 N   ALTER TABLE ONLY triplek.document_type DROP CONSTRAINT uq_name_document_type;
       triplek            postgres    false    226         �           2606    33563    piece uq_name_piece 
   CONSTRAINT     U   ALTER TABLE ONLY triplek.piece
    ADD CONSTRAINT uq_name_piece UNIQUE (name_piece);
 >   ALTER TABLE ONLY triplek.piece DROP CONSTRAINT uq_name_piece;
       triplek            postgres    false    225         �           2606    25155    role uq_name_role 
   CONSTRAINT     R   ALTER TABLE ONLY triplek.role
    ADD CONSTRAINT uq_name_role UNIQUE (name_role);
 <   ALTER TABLE ONLY triplek.role DROP CONSTRAINT uq_name_role;
       triplek            postgres    false    218         �           2606    25135    school uq_name_school 
   CONSTRAINT     X   ALTER TABLE ONLY triplek.school
    ADD CONSTRAINT uq_name_school UNIQUE (name_school);
 @   ALTER TABLE ONLY triplek.school DROP CONSTRAINT uq_name_school;
       triplek            postgres    false    216         �           2606    33539    size uq_name_size 
   CONSTRAINT     R   ALTER TABLE ONLY triplek.size
    ADD CONSTRAINT uq_name_size UNIQUE (name_size);
 <   ALTER TABLE ONLY triplek.size DROP CONSTRAINT uq_name_size;
       triplek            postgres    false    214         �           2606    33552    type_piece uq_name_type_piece 
   CONSTRAINT     d   ALTER TABLE ONLY triplek.type_piece
    ADD CONSTRAINT uq_name_type_piece UNIQUE (name_type_piece);
 H   ALTER TABLE ONLY triplek.type_piece DROP CONSTRAINT uq_name_type_piece;
       triplek            postgres    false    228         �           2606    33479    uniform uq_name_uniform 
   CONSTRAINT     [   ALTER TABLE ONLY triplek.uniform
    ADD CONSTRAINT uq_name_uniform UNIQUE (name_uniform);
 B   ALTER TABLE ONLY triplek.uniform DROP CONSTRAINT uq_name_uniform;
       triplek            postgres    false    223         �           2606    25174    usser uq_usser_name 
   CONSTRAINT     U   ALTER TABLE ONLY triplek.usser
    ADD CONSTRAINT uq_usser_name UNIQUE (usser_name);
 >   ALTER TABLE ONLY triplek.usser DROP CONSTRAINT uq_usser_name;
       triplek            postgres    false    220         �           2620    33561    piece calcular_total    TRIGGER     �   CREATE TRIGGER calcular_total AFTER INSERT OR DELETE OR UPDATE ON triplek.piece FOR EACH ROW EXECUTE FUNCTION triplek.total_uniform();
 .   DROP TRIGGER calcular_total ON triplek.piece;
       triplek          postgres    false    225    245         �           2620    33585    piece llenar_audi_piece    TRIGGER     �   CREATE TRIGGER llenar_audi_piece AFTER DELETE OR UPDATE ON triplek.piece FOR EACH ROW EXECUTE FUNCTION triplek.audi_piece_func();
 1   DROP TRIGGER llenar_audi_piece ON triplek.piece;
       triplek          postgres    false    233    225         �           2606    33533    person fk_document_type    FK CONSTRAINT     �   ALTER TABLE ONLY triplek.person
    ADD CONSTRAINT fk_document_type FOREIGN KEY (id_document_type) REFERENCES triplek.document_type(id_document_type);
 B   ALTER TABLE ONLY triplek.person DROP CONSTRAINT fk_document_type;
       triplek          postgres    false    3286    221    226         �           2606    25175    usser fk_id_role    FK CONSTRAINT     u   ALTER TABLE ONLY triplek.usser
    ADD CONSTRAINT fk_id_role FOREIGN KEY (id_role) REFERENCES triplek.role(id_role);
 ;   ALTER TABLE ONLY triplek.usser DROP CONSTRAINT fk_id_role;
       triplek          postgres    false    3266    218    220         �           2606    33507    piece fk_id_school_piece    FK CONSTRAINT     �   ALTER TABLE ONLY triplek.piece
    ADD CONSTRAINT fk_id_school_piece FOREIGN KEY (id_school_piece) REFERENCES triplek.school(id_school);
 C   ALTER TABLE ONLY triplek.piece DROP CONSTRAINT fk_id_school_piece;
       triplek          postgres    false    225    3262    216         �           2606    33480    uniform fk_school    FK CONSTRAINT     |   ALTER TABLE ONLY triplek.uniform
    ADD CONSTRAINT fk_school FOREIGN KEY (id_school) REFERENCES triplek.school(id_school);
 <   ALTER TABLE ONLY triplek.uniform DROP CONSTRAINT fk_school;
       triplek          postgres    false    223    3262    216         �           2606    33485    uniform fk_size    FK CONSTRAINT     t   ALTER TABLE ONLY triplek.uniform
    ADD CONSTRAINT fk_size FOREIGN KEY (id_size) REFERENCES triplek.size(id_size);
 :   ALTER TABLE ONLY triplek.uniform DROP CONSTRAINT fk_size;
       triplek          postgres    false    214    223    3258         �           2606    33517    piece fk_size_piece    FK CONSTRAINT     x   ALTER TABLE ONLY triplek.piece
    ADD CONSTRAINT fk_size_piece FOREIGN KEY (id_size) REFERENCES triplek.size(id_size);
 >   ALTER TABLE ONLY triplek.piece DROP CONSTRAINT fk_size_piece;
       triplek          postgres    false    225    3258    214         �           2606    33553    piece fk_type_piece    FK CONSTRAINT     �   ALTER TABLE ONLY triplek.piece
    ADD CONSTRAINT fk_type_piece FOREIGN KEY (type_piece) REFERENCES triplek.type_piece(id_type_piece);
 >   ALTER TABLE ONLY triplek.piece DROP CONSTRAINT fk_type_piece;
       triplek          postgres    false    228    3290    225         �           2606    25195    person fk_usser    FK CONSTRAINT     w   ALTER TABLE ONLY triplek.person
    ADD CONSTRAINT fk_usser FOREIGN KEY (id_usser) REFERENCES triplek.usser(id_usser);
 :   ALTER TABLE ONLY triplek.person DROP CONSTRAINT fk_usser;
       triplek          postgres    false    3270    221    220                                                                                           3467.dat                                                                                            0000600 0004000 0002000 00000001533 14440514412 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	CC	1065232109	2	BREYNNER FABIAN	ARIZA FLOREZ	3155559988	BFARIZAF@UFPSO.EDU.CO	BREYNNER	12345	2023-06-05 22:16:48.443164
2	CC	1065232109	2	BREYNNER FABIAN	ARIZA FLOREZ	3155559988	BFARIZAF@UFPSO.EDU.CO	BREYNNER	12345	2023-06-05 22:18:26.946169
3	CC	1065232109	2	BREYNNER FABIAN	ARIZA FLOREZ	3155559988	BFARIZAF@UFPSO.EDU.CO	BREYNNER	12345	2023-06-05 22:19:42.352797
4	CC	1065232109	2	BREYNNER FABIAN	ARIZA FLOREZ	3155559988	BFARIZAF@UFPSO.EDU.CO	BREYNNER	12345	2023-06-06 08:22:41.746273
5	CC	1065232109	2	BREYNNER FABIAN	ARIZA FLOREZ	3155559988	BFARIZAF@UFPSO.EDU.CO	BREYNNER	12345	2023-06-06 08:35:15.241687
6	CC	1065232109	2	BREYNNER FABIAN	ARIZA FLOREZ	3155559988	BFARIZAF@UFPSO.EDU.CO	BREYNNER	12345	2023-06-06 10:46:10.424585
7	CC	1065232109	2	BREYNNER FABIAN	ARIZA FLOREZ	3155559988	BFARIZAF@UFPSO.EDU.CO	BREYNNER	12345	2023-06-08 22:02:43.852817
\.


                                                                                                                                                                     3465.dat                                                                                            0000600 0004000 0002000 00000001032 14440514412 0014246 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	43	2	27	2	CAMIBUSO DIARIO INSTITUCION EDUCATIVA COLEGIO AGUSTINA FERRO	6	F	7	45	30000	2023-06-05 21:45:56.334426
2	44	2	27	2	FALDA DIARIO INSTITUCION EDUCATIVA COLEGIO AGUSTINA FERRO	6	F	1	3	12000	2023-06-06 08:32:18.560581
3	46	3	28	3	PANTALON DIARIO COLEGIO JOSE EUSEBIO CARO	12	M	2	30	45000	2023-06-06 10:52:14.965151
4	45	2	27	2	CAMIBUSO FISICA INSTITUCION EDUCATIVA COLEGIO AGUSTINA FERRO	6	F	7	30	30000	2023-06-08 22:03:13.863584
5	47	3	28	3	CAMISA DIARIO COLEGIO JOSE EUSEBIO CARO	12	M	5	12	30000	2023-06-08 22:03:15.784196
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      3461.dat                                                                                            0000600 0004000 0002000 00000000035 14440514412 0014244 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        CC	CEDULA DE CIUDADANIA
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   3456.dat                                                                                            0000600 0004000 0002000 00000000123 14440514412 0014246 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1065232109	2	BREYNNER FABIAN	ARIZA FLOREZ	3155559988	BFARIZAF@UFPSO.EDU.CO	CC
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                             3460.dat                                                                                            0000600 0004000 0002000 00000000130 14440514412 0014237 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        48	1	0	PANTALON FISICA COLEGIO FRANCISCO FERNANDEZ DE CONTRERAS	6	M	F	12	20000	2	0
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                        3453.dat                                                                                            0000600 0004000 0002000 00000000041 14440514412 0014242 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	ADMINISTRADOR
2	ASISTENTE
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               3451.dat                                                                                            0000600 0004000 0002000 00000000324 14440514412 0014244 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	COLEGIO FRANCISCO FERNANDEZ DE CONTRERAS
2	INSTITUCION EDUCATIVA COLEGIO AGUSTINA FERRO
3	COLEGIO JOSE EUSEBIO CARO
4	INSTITUCION EDUCATIVA LA PRESENTACION
5	INSTITUTO TECNICO INDUSTRIAL LUCIO PABON NUNES
\.


                                                                                                                                                                                                                                                                                                            3449.dat                                                                                            0000600 0004000 0002000 00000000176 14440514412 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        6	TALLA SEIS
8	TALLA OCHO
10	TALLA DIEZ
12	TALLA DOCE
14	TALLA CATORCE
16	TALLA DIECISEIS
S	TALLA SMALL
M	MEDIUM
L	LARGE
\.


                                                                                                                                                                                                                                                                                                                                                                                                  3463.dat                                                                                            0000600 0004000 0002000 00000000117 14440514412 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	FALDA
2	PANTALON
3	SUDADERA
4	PANTALONETA
5	CAMISA
6	CHALECO
7	CAMIBUSO
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                 3458.dat                                                                                            0000600 0004000 0002000 00000000307 14440514412 0014254 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        27	UNIFORME INSTITUCION EDUCATIVA COLEGIO AGUSTINA FERRO DIARIO FEMENINO TALLA S	2	S	F	D	2	30000	2000	30000
28	UNIFORME COLEGIO JOSE EUSEBIO CARO DIARIO MASCULINO TALLA 12	3	12	M	D	2	\N	2000	\N
\.


                                                                                                                                                                                                                                                                                                                         3455.dat                                                                                            0000600 0004000 0002000 00000000054 14440514412 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	I	LAURA	12345
2	2	A	BREYNNER	12345
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    restore.sql                                                                                         0000600 0004000 0002000 00000062670 14440514412 0015376 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE "TripleKKK";
--
-- Name: TripleKKK; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "TripleKKK" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Colombia.1252';


ALTER DATABASE "TripleKKK" OWNER TO postgres;

\connect "TripleKKK"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: triplek; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA triplek;


ALTER SCHEMA triplek OWNER TO postgres;

--
-- Name: audi_piece_func(); Type: FUNCTION; Schema: triplek; Owner: postgres
--

CREATE FUNCTION triplek.audi_piece_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	INSERT INTO TRIPLEK.AUDI_PIECE (ID_AUDI_PIECE,ID_PIECE,ID_SCHOOL_PIECE,ID_UNIFORM,ID_SCHOOL_UNIFORM,NAME_PIECE,ID_SIZE,
								   GENDER_PIECE,TYPE_PIECE,AMOUNT_PIECE,PRICE_PIECE)
	VALUES (DEFAULT,OLD.ID_PIECE,OLD.ID_SCHOOL_PIECE,OLD.ID_UNIFORM,OLD.ID_SCHOOL_UNIFORM,OLD.NAME_PIECE,OLD.ID_SIZE,
								   OLD.GENDER_PIECE,OLD.TYPE_PIECE,OLD.AMOUNT_PIECE,OLD.PRICE_PIECE);
RETURN NEW;								  
END;
$$;


ALTER FUNCTION triplek.audi_piece_func() OWNER TO postgres;

--
-- Name: total_uniform(); Type: FUNCTION; Schema: triplek; Owner: postgres
--

CREATE FUNCTION triplek.total_uniform() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 CP INTEGER; -- Variable para saber la cantidad de piezas que contiene el uniforme
 SBT DECIMAL; -- Variable para tener el subtotal del precio del uniforme
 TU DECIMAL; -- Variable para tener el total del uniforme
 NP INTEGER; -- NUMERO DE PIEZAS CON LAS QUE SE CONFORMA UN UNIFORME
 DESCU DECIMAL; -- Variable para almacenar el descuento 
BEGIN
	IF (TG_OP = 'INSERT') THEN -- Cuando se realizo una insercion
		IF (NEW.ID_UNIFORM <> '0' AND NEW.ID_SCHOOL_UNIFORM != 0 ) THEN
			SELECT COUNT(*),SUM(PIE.PRICE_PIECE) INTO CP,SBT FROM TRIPLEK.UNIFORM UNI
			INNER JOIN TRIPLEK.PIECE PIE
			ON (UNI.ID_UNIFORM = PIE.ID_UNIFORM) 
			AND (UNI.ID_SCHOOL = PIE.ID_SCHOOL_UNIFORM);
			-- Obtener el numero de piezas y el descuento de un uniforme
			SELECT NUM_PIECE,DESCONT_UNIFORM INTO NP,DESCU FROM TRIPLEK.UNIFORM
			WHERE ID_SCHOOL = NEW.ID_SCHOOL_UNIFORM
			AND ID_UNIFORM = NEW.ID_UNIFORM;		
			IF (CP =  NP) THEN
				TU := SBT - DESCU; --Aplicar el descuento
			ELSE
				TU := SBT; --Precio cuando no se aplica el descuento 
			END IF;
			UPDATE TRIPLEK.UNIFORM SET SUB_TOTAL_UNIFORM = SBT, TOTAL_UNIFORM = TU
			WHERE ID_SCHOOL = NEW.ID_SCHOOL_UNIFORM
			AND ID_UNIFORM = NEW.ID_UNIFORM;
			RETURN NEW;				
		END IF;		
	ELSIF (TG_OP = 'DELETE') THEN -- Cuando se realiza una eliminacion 
		IF (OLD.ID_UNIFORM <> '0' AND OLD.ID_SCHOOL_UNIFORM != 0 ) THEN
			SELECT COUNT(*),SUM(PIE.PRICE_PIECE) INTO CP,SBT FROM TRIPLEK.UNIFORM UNI
			INNER JOIN TRIPLEK.PIECE PIE
			ON (UNI.ID_UNIFORM = PIE.ID_UNIFORM) 
			AND (UNI.ID_SCHOOL = PIE.ID_SCHOOL_UNIFORM);
			-- Obtener el numero de piezas y el descuento de un uniforme
			SELECT NUM_PIECE,DESCONT_UNIFORM INTO NP,DESCU FROM TRIPLEK.UNIFORM
			WHERE ID_SCHOOL = OLD.ID_SCHOOL_UNIFORM
			AND ID_UNIFORM = OLD.ID_UNIFORM;		
			CP := CP + 1;
			TU := SBT;
			UPDATE TRIPLEK.UNIFORM SET SUB_TOTAL_UNIFORM = SBT, TOTAL_UNIFORM = TU
			WHERE ID_SCHOOL = OLD.ID_SCHOOL_UNIFORM
			AND ID_UNIFORM = OLD.ID_UNIFORM;
			RETURN NEW;
		END IF;		
	END IF;
RETURN NEW;		
END;
$$;


ALTER FUNCTION triplek.total_uniform() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audi_login; Type: TABLE; Schema: triplek; Owner: postgres
--

CREATE TABLE triplek.audi_login (
    id_audi_login integer NOT NULL,
    id_document_type character varying(5),
    number_document character varying(12) NOT NULL,
    id_usser integer,
    name_person character varying(30),
    last_name_person character varying(30),
    phone_person character varying(10),
    email_person character varying(50),
    usser_name character varying(30),
    usser_password character varying(50),
    date_audi_login timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE triplek.audi_login OWNER TO postgres;

--
-- Name: audi_login_id_audi_login_seq; Type: SEQUENCE; Schema: triplek; Owner: postgres
--

CREATE SEQUENCE triplek.audi_login_id_audi_login_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE triplek.audi_login_id_audi_login_seq OWNER TO postgres;

--
-- Name: audi_login_id_audi_login_seq; Type: SEQUENCE OWNED BY; Schema: triplek; Owner: postgres
--

ALTER SEQUENCE triplek.audi_login_id_audi_login_seq OWNED BY triplek.audi_login.id_audi_login;


--
-- Name: audi_piece; Type: TABLE; Schema: triplek; Owner: postgres
--

CREATE TABLE triplek.audi_piece (
    id_audi_piece integer NOT NULL,
    id_piece character varying(5) NOT NULL,
    id_school_piece integer NOT NULL,
    id_uniform character varying(5),
    id_school_uniform integer,
    name_piece character varying(100),
    id_size character varying(4),
    gender_piece character(1),
    type_piece character(1),
    amount_piece integer,
    price_piece numeric,
    date_audi_piece timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE triplek.audi_piece OWNER TO postgres;

--
-- Name: audi_piece_id_audi_piece_seq; Type: SEQUENCE; Schema: triplek; Owner: postgres
--

CREATE SEQUENCE triplek.audi_piece_id_audi_piece_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE triplek.audi_piece_id_audi_piece_seq OWNER TO postgres;

--
-- Name: audi_piece_id_audi_piece_seq; Type: SEQUENCE OWNED BY; Schema: triplek; Owner: postgres
--

ALTER SEQUENCE triplek.audi_piece_id_audi_piece_seq OWNED BY triplek.audi_piece.id_audi_piece;


--
-- Name: document_type; Type: TABLE; Schema: triplek; Owner: postgres
--

CREATE TABLE triplek.document_type (
    id_document_type character varying(5) NOT NULL,
    name_document_type character varying(30),
    CONSTRAINT nn_name_document_type CHECK ((name_document_type IS NOT NULL))
);


ALTER TABLE triplek.document_type OWNER TO postgres;

--
-- Name: person; Type: TABLE; Schema: triplek; Owner: postgres
--

CREATE TABLE triplek.person (
    number_document character varying(12) NOT NULL,
    id_usser integer,
    name_person character varying(30),
    last_name_person character varying(30),
    phone_person character varying(10),
    email_person character varying(50),
    id_document_type character varying(5),
    CONSTRAINT nn_last_name_person CHECK ((last_name_person IS NOT NULL)),
    CONSTRAINT nn_name_person CHECK ((name_person IS NOT NULL))
);


ALTER TABLE triplek.person OWNER TO postgres;

--
-- Name: seq_piece; Type: SEQUENCE; Schema: triplek; Owner: postgres
--

CREATE SEQUENCE triplek.seq_piece
    START WITH 20
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE triplek.seq_piece OWNER TO postgres;

--
-- Name: piece; Type: TABLE; Schema: triplek; Owner: postgres
--

CREATE TABLE triplek.piece (
    id_piece character varying(5) DEFAULT to_char(nextval('triplek.seq_piece'::regclass), 'FM00'::text) NOT NULL,
    id_school_piece integer NOT NULL,
    id_uniform character varying(5),
    name_piece character varying(100),
    id_size character varying(4),
    gender_piece character(1),
    type_piece_use character(1),
    amount_piece integer,
    price_piece numeric,
    type_piece integer,
    id_school_uniform integer,
    CONSTRAINT ck_amount_piece CHECK ((amount_piece >= 0)),
    CONSTRAINT ck_gender_piece CHECK ((gender_piece = ANY (ARRAY['M'::bpchar, 'F'::bpchar]))),
    CONSTRAINT ck_name_piece CHECK ((name_piece IS NOT NULL)),
    CONSTRAINT ck_type_piece CHECK ((type_piece_use = ANY (ARRAY['D'::bpchar, 'F'::bpchar]))),
    CONSTRAINT nn_gender_piece CHECK ((gender_piece IS NOT NULL)),
    CONSTRAINT nn_id_size CHECK ((id_size IS NOT NULL)),
    CONSTRAINT nn_name_piece CHECK ((name_piece IS NOT NULL)),
    CONSTRAINT nn_type_piece CHECK ((type_piece_use IS NOT NULL))
);


ALTER TABLE triplek.piece OWNER TO postgres;

--
-- Name: role; Type: TABLE; Schema: triplek; Owner: postgres
--

CREATE TABLE triplek.role (
    id_role integer NOT NULL,
    name_role character varying(30),
    CONSTRAINT nn_name_role CHECK ((name_role IS NOT NULL))
);


ALTER TABLE triplek.role OWNER TO postgres;

--
-- Name: role_id_role_seq; Type: SEQUENCE; Schema: triplek; Owner: postgres
--

CREATE SEQUENCE triplek.role_id_role_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE triplek.role_id_role_seq OWNER TO postgres;

--
-- Name: role_id_role_seq; Type: SEQUENCE OWNED BY; Schema: triplek; Owner: postgres
--

ALTER SEQUENCE triplek.role_id_role_seq OWNED BY triplek.role.id_role;


--
-- Name: school; Type: TABLE; Schema: triplek; Owner: postgres
--

CREATE TABLE triplek.school (
    id_school integer NOT NULL,
    name_school character varying(100),
    CONSTRAINT nn_name_school CHECK ((name_school IS NOT NULL))
);


ALTER TABLE triplek.school OWNER TO postgres;

--
-- Name: school_id_school_seq; Type: SEQUENCE; Schema: triplek; Owner: postgres
--

CREATE SEQUENCE triplek.school_id_school_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE triplek.school_id_school_seq OWNER TO postgres;

--
-- Name: school_id_school_seq; Type: SEQUENCE OWNED BY; Schema: triplek; Owner: postgres
--

ALTER SEQUENCE triplek.school_id_school_seq OWNED BY triplek.school.id_school;


--
-- Name: seq_uniform; Type: SEQUENCE; Schema: triplek; Owner: postgres
--

CREATE SEQUENCE triplek.seq_uniform
    START WITH 20
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE triplek.seq_uniform OWNER TO postgres;

--
-- Name: size; Type: TABLE; Schema: triplek; Owner: postgres
--

CREATE TABLE triplek.size (
    id_size character varying(4) NOT NULL,
    name_size character varying(20),
    CONSTRAINT nn_name_size CHECK ((name_size IS NOT NULL))
);


ALTER TABLE triplek.size OWNER TO postgres;

--
-- Name: type_piece; Type: TABLE; Schema: triplek; Owner: postgres
--

CREATE TABLE triplek.type_piece (
    id_type_piece integer NOT NULL,
    name_type_piece character varying(20),
    CONSTRAINT nn_name_type_piece CHECK ((name_type_piece IS NOT NULL))
);


ALTER TABLE triplek.type_piece OWNER TO postgres;

--
-- Name: type_piece_id_type_piece_seq; Type: SEQUENCE; Schema: triplek; Owner: postgres
--

CREATE SEQUENCE triplek.type_piece_id_type_piece_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE triplek.type_piece_id_type_piece_seq OWNER TO postgres;

--
-- Name: type_piece_id_type_piece_seq; Type: SEQUENCE OWNED BY; Schema: triplek; Owner: postgres
--

ALTER SEQUENCE triplek.type_piece_id_type_piece_seq OWNED BY triplek.type_piece.id_type_piece;


--
-- Name: uniform; Type: TABLE; Schema: triplek; Owner: postgres
--

CREATE TABLE triplek.uniform (
    id_uniform character varying(5) DEFAULT to_char(nextval('triplek.seq_uniform'::regclass), 'FM00'::text) NOT NULL,
    name_uniform character varying(100),
    id_school integer NOT NULL,
    id_size character varying(4),
    gender_uniform character(1),
    type_uniform character(1),
    num_piece integer,
    sub_total_uniform numeric,
    descont_uniform numeric,
    total_uniform numeric,
    CONSTRAINT ck_gender_uniform CHECK ((gender_uniform = ANY (ARRAY['M'::bpchar, 'F'::bpchar]))),
    CONSTRAINT ck_name_uniform CHECK ((name_uniform IS NOT NULL)),
    CONSTRAINT ck_type_uniform CHECK ((type_uniform = ANY (ARRAY['D'::bpchar, 'F'::bpchar]))),
    CONSTRAINT nn_gender_uniform CHECK ((gender_uniform IS NOT NULL)),
    CONSTRAINT nn_id_size CHECK ((id_size IS NOT NULL)),
    CONSTRAINT nn_type_uniform CHECK ((type_uniform IS NOT NULL))
);


ALTER TABLE triplek.uniform OWNER TO postgres;

--
-- Name: usser; Type: TABLE; Schema: triplek; Owner: postgres
--

CREATE TABLE triplek.usser (
    id_usser integer NOT NULL,
    id_role integer,
    state_usser character(1),
    usser_name character varying(30),
    usser_password character varying(50),
    CONSTRAINT ck_state_usser CHECK ((state_usser = ANY (ARRAY['A'::bpchar, 'I'::bpchar]))),
    CONSTRAINT nn_state_usser CHECK ((state_usser IS NOT NULL)),
    CONSTRAINT nn_usser_name CHECK ((usser_name IS NOT NULL)),
    CONSTRAINT nn_usser_password CHECK ((usser_password IS NOT NULL))
);


ALTER TABLE triplek.usser OWNER TO postgres;

--
-- Name: usser_id_usser_seq; Type: SEQUENCE; Schema: triplek; Owner: postgres
--

CREATE SEQUENCE triplek.usser_id_usser_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE triplek.usser_id_usser_seq OWNER TO postgres;

--
-- Name: usser_id_usser_seq; Type: SEQUENCE OWNED BY; Schema: triplek; Owner: postgres
--

ALTER SEQUENCE triplek.usser_id_usser_seq OWNED BY triplek.usser.id_usser;


--
-- Name: audi_login id_audi_login; Type: DEFAULT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.audi_login ALTER COLUMN id_audi_login SET DEFAULT nextval('triplek.audi_login_id_audi_login_seq'::regclass);


--
-- Name: audi_piece id_audi_piece; Type: DEFAULT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.audi_piece ALTER COLUMN id_audi_piece SET DEFAULT nextval('triplek.audi_piece_id_audi_piece_seq'::regclass);


--
-- Name: role id_role; Type: DEFAULT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.role ALTER COLUMN id_role SET DEFAULT nextval('triplek.role_id_role_seq'::regclass);


--
-- Name: school id_school; Type: DEFAULT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.school ALTER COLUMN id_school SET DEFAULT nextval('triplek.school_id_school_seq'::regclass);


--
-- Name: type_piece id_type_piece; Type: DEFAULT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.type_piece ALTER COLUMN id_type_piece SET DEFAULT nextval('triplek.type_piece_id_type_piece_seq'::regclass);


--
-- Name: usser id_usser; Type: DEFAULT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.usser ALTER COLUMN id_usser SET DEFAULT nextval('triplek.usser_id_usser_seq'::regclass);


--
-- Data for Name: audi_login; Type: TABLE DATA; Schema: triplek; Owner: postgres
--

COPY triplek.audi_login (id_audi_login, id_document_type, number_document, id_usser, name_person, last_name_person, phone_person, email_person, usser_name, usser_password, date_audi_login) FROM stdin;
\.
COPY triplek.audi_login (id_audi_login, id_document_type, number_document, id_usser, name_person, last_name_person, phone_person, email_person, usser_name, usser_password, date_audi_login) FROM '$$PATH$$/3467.dat';

--
-- Data for Name: audi_piece; Type: TABLE DATA; Schema: triplek; Owner: postgres
--

COPY triplek.audi_piece (id_audi_piece, id_piece, id_school_piece, id_uniform, id_school_uniform, name_piece, id_size, gender_piece, type_piece, amount_piece, price_piece, date_audi_piece) FROM stdin;
\.
COPY triplek.audi_piece (id_audi_piece, id_piece, id_school_piece, id_uniform, id_school_uniform, name_piece, id_size, gender_piece, type_piece, amount_piece, price_piece, date_audi_piece) FROM '$$PATH$$/3465.dat';

--
-- Data for Name: document_type; Type: TABLE DATA; Schema: triplek; Owner: postgres
--

COPY triplek.document_type (id_document_type, name_document_type) FROM stdin;
\.
COPY triplek.document_type (id_document_type, name_document_type) FROM '$$PATH$$/3461.dat';

--
-- Data for Name: person; Type: TABLE DATA; Schema: triplek; Owner: postgres
--

COPY triplek.person (number_document, id_usser, name_person, last_name_person, phone_person, email_person, id_document_type) FROM stdin;
\.
COPY triplek.person (number_document, id_usser, name_person, last_name_person, phone_person, email_person, id_document_type) FROM '$$PATH$$/3456.dat';

--
-- Data for Name: piece; Type: TABLE DATA; Schema: triplek; Owner: postgres
--

COPY triplek.piece (id_piece, id_school_piece, id_uniform, name_piece, id_size, gender_piece, type_piece_use, amount_piece, price_piece, type_piece, id_school_uniform) FROM stdin;
\.
COPY triplek.piece (id_piece, id_school_piece, id_uniform, name_piece, id_size, gender_piece, type_piece_use, amount_piece, price_piece, type_piece, id_school_uniform) FROM '$$PATH$$/3460.dat';

--
-- Data for Name: role; Type: TABLE DATA; Schema: triplek; Owner: postgres
--

COPY triplek.role (id_role, name_role) FROM stdin;
\.
COPY triplek.role (id_role, name_role) FROM '$$PATH$$/3453.dat';

--
-- Data for Name: school; Type: TABLE DATA; Schema: triplek; Owner: postgres
--

COPY triplek.school (id_school, name_school) FROM stdin;
\.
COPY triplek.school (id_school, name_school) FROM '$$PATH$$/3451.dat';

--
-- Data for Name: size; Type: TABLE DATA; Schema: triplek; Owner: postgres
--

COPY triplek.size (id_size, name_size) FROM stdin;
\.
COPY triplek.size (id_size, name_size) FROM '$$PATH$$/3449.dat';

--
-- Data for Name: type_piece; Type: TABLE DATA; Schema: triplek; Owner: postgres
--

COPY triplek.type_piece (id_type_piece, name_type_piece) FROM stdin;
\.
COPY triplek.type_piece (id_type_piece, name_type_piece) FROM '$$PATH$$/3463.dat';

--
-- Data for Name: uniform; Type: TABLE DATA; Schema: triplek; Owner: postgres
--

COPY triplek.uniform (id_uniform, name_uniform, id_school, id_size, gender_uniform, type_uniform, num_piece, sub_total_uniform, descont_uniform, total_uniform) FROM stdin;
\.
COPY triplek.uniform (id_uniform, name_uniform, id_school, id_size, gender_uniform, type_uniform, num_piece, sub_total_uniform, descont_uniform, total_uniform) FROM '$$PATH$$/3458.dat';

--
-- Data for Name: usser; Type: TABLE DATA; Schema: triplek; Owner: postgres
--

COPY triplek.usser (id_usser, id_role, state_usser, usser_name, usser_password) FROM stdin;
\.
COPY triplek.usser (id_usser, id_role, state_usser, usser_name, usser_password) FROM '$$PATH$$/3455.dat';

--
-- Name: audi_login_id_audi_login_seq; Type: SEQUENCE SET; Schema: triplek; Owner: postgres
--

SELECT pg_catalog.setval('triplek.audi_login_id_audi_login_seq', 7, true);


--
-- Name: audi_piece_id_audi_piece_seq; Type: SEQUENCE SET; Schema: triplek; Owner: postgres
--

SELECT pg_catalog.setval('triplek.audi_piece_id_audi_piece_seq', 5, true);


--
-- Name: role_id_role_seq; Type: SEQUENCE SET; Schema: triplek; Owner: postgres
--

SELECT pg_catalog.setval('triplek.role_id_role_seq', 2, true);


--
-- Name: school_id_school_seq; Type: SEQUENCE SET; Schema: triplek; Owner: postgres
--

SELECT pg_catalog.setval('triplek.school_id_school_seq', 5, true);


--
-- Name: seq_piece; Type: SEQUENCE SET; Schema: triplek; Owner: postgres
--

SELECT pg_catalog.setval('triplek.seq_piece', 48, true);


--
-- Name: seq_uniform; Type: SEQUENCE SET; Schema: triplek; Owner: postgres
--

SELECT pg_catalog.setval('triplek.seq_uniform', 28, true);


--
-- Name: type_piece_id_type_piece_seq; Type: SEQUENCE SET; Schema: triplek; Owner: postgres
--

SELECT pg_catalog.setval('triplek.type_piece_id_type_piece_seq', 7, true);


--
-- Name: usser_id_usser_seq; Type: SEQUENCE SET; Schema: triplek; Owner: postgres
--

SELECT pg_catalog.setval('triplek.usser_id_usser_seq', 2, true);


--
-- Name: audi_piece audi_piece_pkey; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.audi_piece
    ADD CONSTRAINT audi_piece_pkey PRIMARY KEY (id_audi_piece, id_piece, id_school_piece);


--
-- Name: audi_login pk_audi_login; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.audi_login
    ADD CONSTRAINT pk_audi_login PRIMARY KEY (id_audi_login, number_document);


--
-- Name: document_type pk_document_type; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.document_type
    ADD CONSTRAINT pk_document_type PRIMARY KEY (id_document_type);


--
-- Name: person pk_person; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.person
    ADD CONSTRAINT pk_person PRIMARY KEY (number_document);


--
-- Name: piece pk_piece; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.piece
    ADD CONSTRAINT pk_piece PRIMARY KEY (id_school_piece, id_piece);


--
-- Name: role pk_role; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.role
    ADD CONSTRAINT pk_role PRIMARY KEY (id_role);


--
-- Name: school pk_school; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.school
    ADD CONSTRAINT pk_school PRIMARY KEY (id_school);


--
-- Name: size pk_size; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.size
    ADD CONSTRAINT pk_size PRIMARY KEY (id_size);


--
-- Name: type_piece pk_type_piece; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.type_piece
    ADD CONSTRAINT pk_type_piece PRIMARY KEY (id_type_piece);


--
-- Name: uniform pk_uniform; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.uniform
    ADD CONSTRAINT pk_uniform PRIMARY KEY (id_school, id_uniform);


--
-- Name: usser pk_usser; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.usser
    ADD CONSTRAINT pk_usser PRIMARY KEY (id_usser);


--
-- Name: person uq_id_usser; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.person
    ADD CONSTRAINT uq_id_usser UNIQUE (id_usser);


--
-- Name: document_type uq_name_document_type; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.document_type
    ADD CONSTRAINT uq_name_document_type UNIQUE (name_document_type);


--
-- Name: piece uq_name_piece; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.piece
    ADD CONSTRAINT uq_name_piece UNIQUE (name_piece);


--
-- Name: role uq_name_role; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.role
    ADD CONSTRAINT uq_name_role UNIQUE (name_role);


--
-- Name: school uq_name_school; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.school
    ADD CONSTRAINT uq_name_school UNIQUE (name_school);


--
-- Name: size uq_name_size; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.size
    ADD CONSTRAINT uq_name_size UNIQUE (name_size);


--
-- Name: type_piece uq_name_type_piece; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.type_piece
    ADD CONSTRAINT uq_name_type_piece UNIQUE (name_type_piece);


--
-- Name: uniform uq_name_uniform; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.uniform
    ADD CONSTRAINT uq_name_uniform UNIQUE (name_uniform);


--
-- Name: usser uq_usser_name; Type: CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.usser
    ADD CONSTRAINT uq_usser_name UNIQUE (usser_name);


--
-- Name: piece calcular_total; Type: TRIGGER; Schema: triplek; Owner: postgres
--

CREATE TRIGGER calcular_total AFTER INSERT OR DELETE OR UPDATE ON triplek.piece FOR EACH ROW EXECUTE FUNCTION triplek.total_uniform();


--
-- Name: piece llenar_audi_piece; Type: TRIGGER; Schema: triplek; Owner: postgres
--

CREATE TRIGGER llenar_audi_piece AFTER DELETE OR UPDATE ON triplek.piece FOR EACH ROW EXECUTE FUNCTION triplek.audi_piece_func();


--
-- Name: person fk_document_type; Type: FK CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.person
    ADD CONSTRAINT fk_document_type FOREIGN KEY (id_document_type) REFERENCES triplek.document_type(id_document_type);


--
-- Name: usser fk_id_role; Type: FK CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.usser
    ADD CONSTRAINT fk_id_role FOREIGN KEY (id_role) REFERENCES triplek.role(id_role);


--
-- Name: piece fk_id_school_piece; Type: FK CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.piece
    ADD CONSTRAINT fk_id_school_piece FOREIGN KEY (id_school_piece) REFERENCES triplek.school(id_school);


--
-- Name: uniform fk_school; Type: FK CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.uniform
    ADD CONSTRAINT fk_school FOREIGN KEY (id_school) REFERENCES triplek.school(id_school);


--
-- Name: uniform fk_size; Type: FK CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.uniform
    ADD CONSTRAINT fk_size FOREIGN KEY (id_size) REFERENCES triplek.size(id_size);


--
-- Name: piece fk_size_piece; Type: FK CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.piece
    ADD CONSTRAINT fk_size_piece FOREIGN KEY (id_size) REFERENCES triplek.size(id_size);


--
-- Name: piece fk_type_piece; Type: FK CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.piece
    ADD CONSTRAINT fk_type_piece FOREIGN KEY (type_piece) REFERENCES triplek.type_piece(id_type_piece);


--
-- Name: person fk_usser; Type: FK CONSTRAINT; Schema: triplek; Owner: postgres
--

ALTER TABLE ONLY triplek.person
    ADD CONSTRAINT fk_usser FOREIGN KEY (id_usser) REFERENCES triplek.usser(id_usser);


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        