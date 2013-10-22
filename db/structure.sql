--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: assignment_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignment_files (
    id integer NOT NULL,
    filename character varying(255),
    assignment_id integer
);


--
-- Name: assignment_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignment_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignment_files_id_seq OWNED BY assignment_files.id;


--
-- Name: assignment_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignment_groups (
    id integer NOT NULL,
    group_id integer,
    assignment_id integer
);


--
-- Name: assignment_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignment_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignment_groups_id_seq OWNED BY assignment_groups.id;


--
-- Name: assignment_rubrics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignment_rubrics (
    id integer NOT NULL,
    assignment_id integer,
    rubric_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: assignment_rubrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignment_rubrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_rubrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignment_rubrics_id_seq OWNED BY assignment_rubrics.id;


--
-- Name: assignment_score_levels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignment_score_levels (
    id integer NOT NULL,
    assignment_id integer NOT NULL,
    name character varying(255) NOT NULL,
    value integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: assignment_score_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignment_score_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_score_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignment_score_levels_id_seq OWNED BY assignment_score_levels.id;


--
-- Name: assignment_submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignment_submissions (
    id integer NOT NULL,
    assignment_id integer,
    user_id integer,
    feedback character varying(255),
    comment character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    attachment_file_name character varying(255),
    attachment_content_type character varying(255),
    attachment_file_size integer,
    attachment_updated_at timestamp without time zone,
    link character varying(255),
    submittable_id integer,
    submittable_type character varying(255),
    text_feedback text,
    text_comment text
);


--
-- Name: assignment_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignment_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignment_submissions_id_seq OWNED BY assignment_submissions.id;


--
-- Name: assignment_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignment_types (
    id integer NOT NULL,
    name character varying(255),
    point_setting character varying(255),
    levels boolean,
    points_predictor_display character varying(255),
    resubmission integer,
    max_value integer,
    percentage_course integer,
    predictor_description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    course_id integer,
    universal_point_value integer,
    minimum_score integer,
    step_value integer DEFAULT 1,
    grade_scheme_id integer,
    due_date_present boolean,
    order_placement integer,
    mass_grade boolean,
    mass_grade_type character varying(255),
    student_weightable boolean,
    student_logged_button_text character varying(255),
    student_logged_revert_button_text character varying(255),
    notify_released boolean DEFAULT true
);


--
-- Name: assignment_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignment_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignment_types_id_seq OWNED BY assignment_types.id;


--
-- Name: assignment_weights; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignment_weights (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    student_id integer NOT NULL,
    assignment_type_id integer NOT NULL,
    weight integer NOT NULL,
    assignment_id integer NOT NULL,
    course_id integer,
    point_total integer DEFAULT 0 NOT NULL
);


--
-- Name: assignment_weights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignment_weights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_weights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignment_weights_id_seq OWNED BY assignment_weights.id;


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignments (
    id integer NOT NULL,
    name character varying(255),
    description text,
    point_total integer,
    due_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    level character varying(255),
    present boolean,
    course_id integer,
    assignment_type_id integer,
    grade_scheme_id integer,
    grade_scope character varying(255) DEFAULT 'Individual'::character varying NOT NULL,
    close_time timestamp without time zone,
    open_time timestamp without time zone,
    required boolean,
    accepts_submissions boolean,
    student_logged boolean,
    release_necessary boolean DEFAULT false NOT NULL,
    open_at timestamp without time zone,
    icon character varying(255),
    can_earn_multiple_times boolean,
    visible boolean DEFAULT true,
    category_id integer,
    resubmissions_allowed boolean,
    max_submissions integer,
    accepts_submissions_until timestamp without time zone,
    accepts_resubmissions_until timestamp without time zone,
    grading_due_at timestamp without time zone,
    role_necessary_for_release character varying(255),
    media character varying(255),
    thumbnail character varying(255),
    media_credit character varying(255),
    media_caption character varying(255),
    points_predictor_display character varying(255),
    notify_released boolean DEFAULT true,
    mass_grade_type character varying(255)
);


--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignments_id_seq OWNED BY assignments.id;


--
-- Name: badge_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE badge_files (
    id integer NOT NULL,
    filename character varying(255),
    badge_id integer
);


--
-- Name: badge_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE badge_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: badge_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE badge_files_id_seq OWNED BY badge_files.id;


--
-- Name: badge_sets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE badge_sets (
    id integer NOT NULL,
    name character varying(255),
    course_id integer,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: badge_sets_courses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE badge_sets_courses (
    course_id integer,
    badge_set_id integer
);


--
-- Name: badge_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE badge_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: badge_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE badge_sets_id_seq OWNED BY badge_sets.id;


--
-- Name: badges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE badges (
    id integer NOT NULL,
    name character varying(255),
    description text,
    point_total integer,
    course_id integer,
    assignment_id integer,
    badge_set_id integer,
    icon character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    visible boolean,
    can_earn_multiple_times boolean
);


--
-- Name: badges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE badges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: badges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE badges_id_seq OWNED BY badges.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    course_id integer
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: challenge_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE challenge_files (
    id integer NOT NULL,
    filename character varying(255),
    challenge_id integer
);


--
-- Name: challenge_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE challenge_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: challenge_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE challenge_files_id_seq OWNED BY challenge_files.id;


--
-- Name: challenge_grades; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE challenge_grades (
    id integer NOT NULL,
    challenge_id integer,
    score integer,
    feedback character varying(255),
    status character varying(255),
    team_id integer,
    final_score integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: challenge_grades_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE challenge_grades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: challenge_grades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE challenge_grades_id_seq OWNED BY challenge_grades.id;


--
-- Name: challenges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE challenges (
    id integer NOT NULL,
    name character varying(255),
    description text,
    point_total integer,
    due_at timestamp without time zone,
    course_id integer,
    points_predictor_display character varying(255),
    visible boolean,
    accepts_submissions boolean,
    release_necessary boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    open_at timestamp without time zone,
    mass_grade boolean,
    mass_grade_type character varying(255),
    levels boolean,
    media character varying(255),
    thumbnail character varying(255),
    media_credit character varying(255),
    media_caption character varying(255)
);


--
-- Name: challenges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE challenges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: challenges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE challenges_id_seq OWNED BY challenges.id;


--
-- Name: course_badge_sets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE course_badge_sets (
    id integer NOT NULL,
    course_id integer,
    badge_set_id integer
);


--
-- Name: course_badge_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE course_badge_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: course_badge_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE course_badge_sets_id_seq OWNED BY course_badge_sets.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE courses (
    id integer NOT NULL,
    name character varying(255),
    courseno character varying(255),
    year character varying(255),
    semester character varying(255),
    grade_scheme_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    badge_setting boolean DEFAULT true,
    team_setting boolean DEFAULT false,
    user_term character varying(255),
    team_term character varying(255),
    homepage_message character varying(255),
    status boolean DEFAULT true,
    group_setting boolean,
    badge_set_id integer,
    assignment_weight_close_at timestamp without time zone,
    team_roles boolean,
    team_leader_term character varying(255),
    group_term character varying(255),
    assignment_weight_type character varying(255),
    accepts_submissions boolean,
    teams_visible boolean,
    badge_use_scope character varying(255),
    weight_term character varying(255),
    predictor_setting boolean,
    badges_value boolean,
    max_group_size integer,
    min_group_size integer,
    shared_badges boolean,
    graph_display boolean,
    default_assignment_weight numeric(4,1) DEFAULT 1.0,
    tagline character varying(255),
    academic_history_visible boolean,
    office character varying(255),
    phone character varying(255),
    class_email character varying(255),
    twitter_handle character varying(255),
    twitter_hashtag character varying(255),
    location character varying(255),
    office_hours character varying(255),
    meeting_times text,
    media_file character varying(255),
    media_credit character varying(255),
    media_caption character varying(255),
    badge_term character varying(255),
    assignment_term character varying(255),
    challenge_term character varying(255),
    use_timeline boolean,
    grading_philosophy text,
    total_assignment_weight integer,
    max_assignment_weight integer,
    check_final_grade boolean,
    character_profiles boolean,
    lti_uid character varying(255),
    team_score_average boolean,
    team_challenges boolean,
    max_assignment_types_weighted integer
);


--
-- Name: earned_badges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE earned_badges (
    id integer NOT NULL,
    badge_id integer,
    submission_id integer,
    course_id integer,
    student_id integer,
    task_id integer,
    grade_id integer,
    group_id integer,
    group_type character varying(255),
    score integer,
    feedback text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    shared boolean
);


--
-- Name: grades; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grades (
    id integer NOT NULL,
    raw_score integer DEFAULT 0,
    assignment_id integer,
    feedback text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    complete boolean,
    semis boolean,
    finals boolean,
    type character varying(255),
    status character varying(255),
    attempted boolean,
    substantial boolean,
    final_score integer,
    submission_id integer,
    course_id integer,
    shared boolean,
    student_id integer,
    task_id integer,
    group_id integer,
    group_type character varying(255),
    score integer,
    assignment_type_id integer,
    point_total integer,
    admin_notes text,
    graded_by_id integer,
    team_id integer,
    released boolean,
    predicted_score integer DEFAULT 0 NOT NULL
);


--
-- Name: score_levels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE score_levels (
    id integer NOT NULL,
    name character varying(255),
    value integer,
    assignment_type_id integer,
    assignment_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tasks (
    id integer NOT NULL,
    assignment_id integer,
    name character varying(255),
    description text,
    due_at timestamp without time zone,
    accepts_submissions boolean,
    "group" boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    course_id integer,
    assignment_type character varying(255),
    type character varying(255),
    taskable_type character varying(255)
);


--
-- Name: course_cache_keys; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW course_cache_keys AS
    SELECT courses.id, courses.id AS course_id, md5(pg_catalog.concat(courses.id, date_part('epoch'::text, courses.updated_at))) AS course_key, md5(pg_catalog.concat(courses.id, (SELECT sum(date_part('epoch'::text, assignments.updated_at)) AS sum FROM assignments WHERE (assignments.course_id = courses.id)), (SELECT sum(date_part('epoch'::text, assignment_types.updated_at)) AS sum FROM assignment_types WHERE (assignment_types.course_id = courses.id)), (SELECT sum(date_part('epoch'::text, score_levels.updated_at)) AS sum FROM (assignment_types JOIN score_levels ON ((score_levels.assignment_type_id = assignment_types.id))) WHERE (assignment_types.course_id = courses.id)))) AS assignments_key, md5(concat((SELECT sum(date_part('epoch'::text, grades.updated_at)) AS sum FROM grades WHERE (grades.course_id = courses.id)))) AS grades_key, md5(pg_catalog.concat((SELECT sum(date_part('epoch'::text, tasks.updated_at)) AS sum FROM tasks WHERE (tasks.course_id = courses.id)), (SELECT sum(date_part('epoch'::text, badges.updated_at)) AS sum FROM badges WHERE (badges.course_id = courses.id)), (SELECT sum(date_part('epoch'::text, earned_badges.updated_at)) AS sum FROM earned_badges WHERE (earned_badges.course_id = courses.id)))) AS badges_key FROM courses;


--
-- Name: course_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE course_categories (
    course_id integer,
    category_id integer
);


--
-- Name: course_grade_scheme_elements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE course_grade_scheme_elements (
    id integer NOT NULL,
    name character varying(255),
    letter_grade character varying(255),
    low_range integer,
    high_range integer,
    course_grade_scheme_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: course_grade_scheme_elements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE course_grade_scheme_elements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: course_grade_scheme_elements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE course_grade_scheme_elements_id_seq OWNED BY course_grade_scheme_elements.id;


--
-- Name: course_grade_schemes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE course_grade_schemes (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    course_id integer
);


--
-- Name: course_grade_schemes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE course_grade_schemes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: course_grade_schemes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE course_grade_schemes_id_seq OWNED BY course_grade_schemes.id;


--
-- Name: course_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE course_memberships (
    id integer NOT NULL,
    course_id integer,
    user_id integer,
    score integer DEFAULT 0 NOT NULL,
    shared_badges boolean,
    character_profile text,
    last_login_at timestamp without time zone,
    auditing boolean DEFAULT false NOT NULL
);


--
-- Name: course_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE course_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: course_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE course_memberships_id_seq OWNED BY course_memberships.id;


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE courses_id_seq OWNED BY courses.id;


--
-- Name: criteria; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE criteria (
    id integer NOT NULL,
    name character varying(255),
    rubric_id integer,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    category character varying(255)
);


--
-- Name: criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE criteria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: criteria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE criteria_id_seq OWNED BY criteria.id;


--
-- Name: criteria_levels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE criteria_levels (
    id integer NOT NULL,
    name character varying(255),
    criteria_id integer,
    description text,
    value integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: criteria_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE criteria_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: criteria_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE criteria_levels_id_seq OWNED BY criteria_levels.id;


--
-- Name: criterium_levels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE criterium_levels (
    id integer NOT NULL,
    name character varying(255),
    criterium_id integer,
    description text,
    value integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: criterium_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE criterium_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: criterium_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE criterium_levels_id_seq OWNED BY criterium_levels.id;


--
-- Name: dashboards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dashboards (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dashboards_id_seq OWNED BY dashboards.id;


--
-- Name: earned_badges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE earned_badges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: earned_badges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE earned_badges_id_seq OWNED BY earned_badges.id;


--
-- Name: elements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE elements (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    badge_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: elements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: elements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE elements_id_seq OWNED BY elements.id;


--
-- Name: faqs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE faqs (
    id integer NOT NULL,
    question character varying(255),
    answer text,
    "order" integer,
    category character varying(255),
    audience character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: faqs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE faqs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: faqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE faqs_id_seq OWNED BY faqs.id;


--
-- Name: grade_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grade_files (
    id integer NOT NULL,
    grade_id integer,
    filename character varying(255)
);


--
-- Name: grade_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE grade_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grade_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE grade_files_id_seq OWNED BY grade_files.id;


--
-- Name: grade_scheme_elements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grade_scheme_elements (
    id integer NOT NULL,
    level character varying(255),
    low_range integer,
    letter character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    grade_scheme_id integer,
    description character varying(255),
    high_range integer,
    team_id integer
);


--
-- Name: grade_scheme_elements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE grade_scheme_elements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grade_scheme_elements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE grade_scheme_elements_id_seq OWNED BY grade_scheme_elements.id;


--
-- Name: grade_schemes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grade_schemes (
    id integer NOT NULL,
    assignment_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    course_id integer,
    name character varying(255),
    description text
);


--
-- Name: grade_schemes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE grade_schemes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grade_schemes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE grade_schemes_id_seq OWNED BY grade_schemes.id;


--
-- Name: grades_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE grades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE grades_id_seq OWNED BY grades.id;


--
-- Name: group_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE group_memberships (
    id integer NOT NULL,
    group_id integer,
    student_id integer,
    accepted character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    course_id integer,
    group_type character varying(255)
);


--
-- Name: group_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_memberships_id_seq OWNED BY group_memberships.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groups (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    course_id integer,
    approved character varying(255),
    proposal character varying(255),
    text_proposal text
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: lti_providers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lti_providers (
    id integer NOT NULL,
    name character varying(255),
    uid character varying(255),
    consumer_key character varying(255),
    consumer_secret character varying(255),
    launch_url character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: lti_providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lti_providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lti_providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lti_providers_id_seq OWNED BY lti_providers.id;


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE submissions (
    id integer NOT NULL,
    assignment_id integer,
    student_id integer,
    feedback character varying(255),
    comment character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    attachment_file_name character varying(255),
    attachment_content_type character varying(255),
    attachment_file_size integer,
    attachment_updated_at timestamp without time zone,
    link character varying(255),
    text_feedback text,
    text_comment text,
    creator_id integer,
    group_id integer,
    graded boolean,
    released_at timestamp without time zone,
    task_id integer,
    course_id integer,
    assignment_type_id integer,
    assignment_type character varying(255)
);


--
-- Name: membership_calculations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW membership_calculations AS
    SELECT m.id, m.id AS course_membership_id, m.course_id, m.user_id, md5(pg_catalog.concat(m.course_id, m.user_id, (SELECT sum(date_part('epoch'::text, earned_badges.updated_at)) AS sum FROM earned_badges WHERE ((earned_badges.course_id = m.course_id) AND (earned_badges.student_id = m.user_id))))) AS earned_badges_key, md5(pg_catalog.concat(m.course_id, m.user_id, (SELECT sum(date_part('epoch'::text, submissions.updated_at)) AS sum FROM submissions WHERE ((submissions.course_id = m.course_id) AND (submissions.student_id = m.user_id))))) AS submissions_key, (SELECT sum(grades.score) AS sum FROM grades WHERE ((grades.course_id = m.course_id) AND (grades.student_id = m.user_id))) AS grade_score_sum, cck.course_key, cck.assignments_key, cck.grades_key, cck.badges_key FROM (course_memberships m JOIN course_cache_keys cck ON ((m.course_id = cck.id)));


--
-- Name: rubric_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rubric_categories (
    id integer NOT NULL,
    rubric_id integer,
    name character varying(255)
);


--
-- Name: rubric_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rubric_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rubric_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rubric_categories_id_seq OWNED BY rubric_categories.id;


--
-- Name: rubrics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rubrics (
    id integer NOT NULL,
    name character varying(255),
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    course_id integer,
    category_id integer
);


--
-- Name: rubrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rubrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rubrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rubrics_id_seq OWNED BY rubrics.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: score_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE score_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: score_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE score_levels_id_seq OWNED BY score_levels.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255),
    crypted_password character varying(255),
    salt character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    reset_password_token character varying(255),
    reset_password_token_expires_at timestamp without time zone,
    reset_password_email_sent_at timestamp without time zone,
    remember_me_token character varying(255),
    remember_me_token_expires_at timestamp without time zone,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    role character varying(255) DEFAULT 'student'::character varying NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    rank integer,
    display_name character varying(255),
    private_display boolean DEFAULT false,
    default_course_id integer,
    final_grade character varying(255),
    visit_count integer,
    predictor_views integer,
    page_views integer,
    team_role character varying(255),
    last_login_at timestamp without time zone,
    last_logout_at timestamp without time zone,
    last_activity_at timestamp without time zone,
    lti_uid character varying(255),
    last_login_from_ip_address character varying(255),
    kerberos_uid character varying(255)
);


--
-- Name: shared_earned_badges; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW shared_earned_badges AS
    SELECT course_memberships.course_id, (((users.first_name)::text || ' '::text) || (users.last_name)::text) AS student_name, users.id AS user_id, earned_badges.id, badges.icon, badges.name FROM (((course_memberships JOIN users ON ((users.id = course_memberships.user_id))) JOIN earned_badges ON ((earned_badges.student_id = users.id))) JOIN badges ON ((badges.id = earned_badges.badge_id))) WHERE (((course_memberships.shared_badges = true) AND (badges.icon IS NOT NULL)) AND (earned_badges.shared = true));


--
-- Name: student_academic_histories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE student_academic_histories (
    id integer NOT NULL,
    student_id integer,
    major character varying(255),
    gpa numeric,
    current_term_credits integer,
    accumulated_credits integer,
    year_in_school character varying(255),
    state_of_residence character varying(255),
    high_school character varying(255),
    athlete boolean,
    act_score integer,
    sat_score integer
);


--
-- Name: student_academic_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE student_academic_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_academic_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE student_academic_histories_id_seq OWNED BY student_academic_histories.id;


--
-- Name: student_assignment_type_weights; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE student_assignment_type_weights (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    student_id integer,
    assignment_type_id integer,
    weight integer NOT NULL
);


--
-- Name: student_assignment_type_weights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE student_assignment_type_weights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_assignment_type_weights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE student_assignment_type_weights_id_seq OWNED BY student_assignment_type_weights.id;


--
-- Name: student_cache_keys; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW student_cache_keys AS
    SELECT cm.id, cm.id AS course_membership_id, cm.course_id, cm.user_id, md5(pg_catalog.concat(cm.course_id, cm.user_id, (SELECT sum(date_part('epoch'::text, earned_badges.updated_at)) AS sum FROM earned_badges WHERE ((earned_badges.course_id = cm.course_id) AND (earned_badges.student_id = cm.user_id))))) AS earned_badges_key, md5(pg_catalog.concat(cm.course_id, cm.user_id, (SELECT sum(date_part('epoch'::text, submissions.updated_at)) AS sum FROM submissions WHERE ((submissions.course_id = cm.course_id) AND (submissions.student_id = cm.user_id))))) AS submissions_key FROM course_memberships cm;


--
-- Name: submission_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE submission_files (
    id integer NOT NULL,
    filename character varying(255) NOT NULL,
    submission_id integer NOT NULL
);


--
-- Name: submission_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE submission_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submission_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE submission_files_id_seq OWNED BY submission_files.id;


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE submissions_id_seq OWNED BY submissions.id;


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tasks_id_seq OWNED BY tasks.id;


--
-- Name: team_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE team_memberships (
    id integer NOT NULL,
    team_id integer,
    student_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: team_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE team_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE team_memberships_id_seq OWNED BY team_memberships.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying(255),
    course_id integer,
    rank integer,
    score integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: themes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE themes (
    id integer NOT NULL,
    name character varying(255),
    filename character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: themes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE themes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE themes_id_seq OWNED BY themes.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_files ALTER COLUMN id SET DEFAULT nextval('assignment_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_groups ALTER COLUMN id SET DEFAULT nextval('assignment_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_rubrics ALTER COLUMN id SET DEFAULT nextval('assignment_rubrics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_score_levels ALTER COLUMN id SET DEFAULT nextval('assignment_score_levels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_submissions ALTER COLUMN id SET DEFAULT nextval('assignment_submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_types ALTER COLUMN id SET DEFAULT nextval('assignment_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_weights ALTER COLUMN id SET DEFAULT nextval('assignment_weights_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments ALTER COLUMN id SET DEFAULT nextval('assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY badge_files ALTER COLUMN id SET DEFAULT nextval('badge_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY badge_sets ALTER COLUMN id SET DEFAULT nextval('badge_sets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY badges ALTER COLUMN id SET DEFAULT nextval('badges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY challenge_files ALTER COLUMN id SET DEFAULT nextval('challenge_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY challenge_grades ALTER COLUMN id SET DEFAULT nextval('challenge_grades_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY challenges ALTER COLUMN id SET DEFAULT nextval('challenges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY course_badge_sets ALTER COLUMN id SET DEFAULT nextval('course_badge_sets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY course_grade_scheme_elements ALTER COLUMN id SET DEFAULT nextval('course_grade_scheme_elements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY course_grade_schemes ALTER COLUMN id SET DEFAULT nextval('course_grade_schemes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY course_memberships ALTER COLUMN id SET DEFAULT nextval('course_memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY criteria ALTER COLUMN id SET DEFAULT nextval('criteria_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY criteria_levels ALTER COLUMN id SET DEFAULT nextval('criteria_levels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY criterium_levels ALTER COLUMN id SET DEFAULT nextval('criterium_levels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY dashboards ALTER COLUMN id SET DEFAULT nextval('dashboards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY earned_badges ALTER COLUMN id SET DEFAULT nextval('earned_badges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY elements ALTER COLUMN id SET DEFAULT nextval('elements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY faqs ALTER COLUMN id SET DEFAULT nextval('faqs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY grade_files ALTER COLUMN id SET DEFAULT nextval('grade_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY grade_scheme_elements ALTER COLUMN id SET DEFAULT nextval('grade_scheme_elements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY grade_schemes ALTER COLUMN id SET DEFAULT nextval('grade_schemes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY grades ALTER COLUMN id SET DEFAULT nextval('grades_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_memberships ALTER COLUMN id SET DEFAULT nextval('group_memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lti_providers ALTER COLUMN id SET DEFAULT nextval('lti_providers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rubric_categories ALTER COLUMN id SET DEFAULT nextval('rubric_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rubrics ALTER COLUMN id SET DEFAULT nextval('rubrics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY score_levels ALTER COLUMN id SET DEFAULT nextval('score_levels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_academic_histories ALTER COLUMN id SET DEFAULT nextval('student_academic_histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_assignment_type_weights ALTER COLUMN id SET DEFAULT nextval('student_assignment_type_weights_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY submission_files ALTER COLUMN id SET DEFAULT nextval('submission_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions ALTER COLUMN id SET DEFAULT nextval('submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tasks ALTER COLUMN id SET DEFAULT nextval('tasks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_memberships ALTER COLUMN id SET DEFAULT nextval('team_memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY themes ALTER COLUMN id SET DEFAULT nextval('themes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: assignment_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignment_files
    ADD CONSTRAINT assignment_files_pkey PRIMARY KEY (id);


--
-- Name: assignment_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignment_groups
    ADD CONSTRAINT assignment_groups_pkey PRIMARY KEY (id);


--
-- Name: assignment_rubrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignment_rubrics
    ADD CONSTRAINT assignment_rubrics_pkey PRIMARY KEY (id);


--
-- Name: assignment_score_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignment_score_levels
    ADD CONSTRAINT assignment_score_levels_pkey PRIMARY KEY (id);


--
-- Name: assignment_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignment_submissions
    ADD CONSTRAINT assignment_submissions_pkey PRIMARY KEY (id);


--
-- Name: assignment_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignment_types
    ADD CONSTRAINT assignment_types_pkey PRIMARY KEY (id);


--
-- Name: assignment_weights_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignment_weights
    ADD CONSTRAINT assignment_weights_pkey PRIMARY KEY (id);


--
-- Name: assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: badge_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY badge_files
    ADD CONSTRAINT badge_files_pkey PRIMARY KEY (id);


--
-- Name: badge_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY badge_sets
    ADD CONSTRAINT badge_sets_pkey PRIMARY KEY (id);


--
-- Name: badges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY badges
    ADD CONSTRAINT badges_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: challenge_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY challenge_files
    ADD CONSTRAINT challenge_files_pkey PRIMARY KEY (id);


--
-- Name: challenge_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY challenge_grades
    ADD CONSTRAINT challenge_grades_pkey PRIMARY KEY (id);


--
-- Name: challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY challenges
    ADD CONSTRAINT challenges_pkey PRIMARY KEY (id);


--
-- Name: course_badge_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY course_badge_sets
    ADD CONSTRAINT course_badge_sets_pkey PRIMARY KEY (id);


--
-- Name: course_grade_scheme_elements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY course_grade_scheme_elements
    ADD CONSTRAINT course_grade_scheme_elements_pkey PRIMARY KEY (id);


--
-- Name: course_grade_schemes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY course_grade_schemes
    ADD CONSTRAINT course_grade_schemes_pkey PRIMARY KEY (id);


--
-- Name: course_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY course_memberships
    ADD CONSTRAINT course_memberships_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: criteria_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY criteria_levels
    ADD CONSTRAINT criteria_levels_pkey PRIMARY KEY (id);


--
-- Name: criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY criteria
    ADD CONSTRAINT criteria_pkey PRIMARY KEY (id);


--
-- Name: criterium_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY criterium_levels
    ADD CONSTRAINT criterium_levels_pkey PRIMARY KEY (id);


--
-- Name: dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);


--
-- Name: earned_badges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY earned_badges
    ADD CONSTRAINT earned_badges_pkey PRIMARY KEY (id);


--
-- Name: elements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elements
    ADD CONSTRAINT elements_pkey PRIMARY KEY (id);


--
-- Name: faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY faqs
    ADD CONSTRAINT faqs_pkey PRIMARY KEY (id);


--
-- Name: grade_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY grade_files
    ADD CONSTRAINT grade_files_pkey PRIMARY KEY (id);


--
-- Name: grade_scheme_elements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY grade_scheme_elements
    ADD CONSTRAINT grade_scheme_elements_pkey PRIMARY KEY (id);


--
-- Name: grade_schemes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY grade_schemes
    ADD CONSTRAINT grade_schemes_pkey PRIMARY KEY (id);


--
-- Name: grades_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (id);


--
-- Name: group_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY group_memberships
    ADD CONSTRAINT group_memberships_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: lti_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lti_providers
    ADD CONSTRAINT lti_providers_pkey PRIMARY KEY (id);


--
-- Name: rubric_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rubric_categories
    ADD CONSTRAINT rubric_categories_pkey PRIMARY KEY (id);


--
-- Name: rubrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rubrics
    ADD CONSTRAINT rubrics_pkey PRIMARY KEY (id);


--
-- Name: score_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY score_levels
    ADD CONSTRAINT score_levels_pkey PRIMARY KEY (id);


--
-- Name: student_academic_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY student_academic_histories
    ADD CONSTRAINT student_academic_histories_pkey PRIMARY KEY (id);


--
-- Name: student_assignment_type_weights_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY student_assignment_type_weights
    ADD CONSTRAINT student_assignment_type_weights_pkey PRIMARY KEY (id);


--
-- Name: submission_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY submission_files
    ADD CONSTRAINT submission_files_pkey PRIMARY KEY (id);


--
-- Name: submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: team_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY team_memberships
    ADD CONSTRAINT team_memberships_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY themes
    ADD CONSTRAINT themes_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_assignment_rubrics_on_assignment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assignment_rubrics_on_assignment_id ON assignment_rubrics USING btree (assignment_id);


--
-- Name: index_assignment_rubrics_on_rubric_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assignment_rubrics_on_rubric_id ON assignment_rubrics USING btree (rubric_id);


--
-- Name: index_assignment_weights_on_assignment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assignment_weights_on_assignment_id ON assignment_weights USING btree (assignment_id);


--
-- Name: index_assignment_weights_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assignment_weights_on_course_id ON assignment_weights USING btree (course_id);


--
-- Name: index_assignment_weights_on_student_id_and_assignment_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assignment_weights_on_student_id_and_assignment_type_id ON assignment_weights USING btree (student_id, assignment_type_id);


--
-- Name: index_assignments_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assignments_on_course_id ON assignments USING btree (course_id);


--
-- Name: index_categories_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_course_id ON categories USING btree (course_id);


--
-- Name: index_course_memberships_on_course_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_course_memberships_on_course_id_and_user_id ON course_memberships USING btree (course_id, user_id);


--
-- Name: index_courses_on_lti_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_courses_on_lti_uid ON courses USING btree (lti_uid);


--
-- Name: index_courses_users_on_course_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_courses_users_on_course_id_and_user_id ON course_memberships USING btree (course_id, user_id);


--
-- Name: index_courses_users_on_user_id_and_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_courses_users_on_user_id_and_course_id ON course_memberships USING btree (user_id, course_id);


--
-- Name: index_grades_on_assignment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_grades_on_assignment_id ON grades USING btree (assignment_id);


--
-- Name: index_grades_on_assignment_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_grades_on_assignment_type_id ON grades USING btree (assignment_type_id);


--
-- Name: index_grades_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_grades_on_course_id ON grades USING btree (course_id);


--
-- Name: index_grades_on_group_id_and_group_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_grades_on_group_id_and_group_type ON grades USING btree (group_id, group_type);


--
-- Name: index_grades_on_score; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_grades_on_score ON grades USING btree (score);


--
-- Name: index_grades_on_task_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_grades_on_task_id ON grades USING btree (task_id);


--
-- Name: index_group_memberships_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_memberships_on_course_id ON group_memberships USING btree (course_id);


--
-- Name: index_group_memberships_on_group_id_and_group_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_memberships_on_group_id_and_group_type ON group_memberships USING btree (group_id, group_type);


--
-- Name: index_group_memberships_on_student_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_group_memberships_on_student_id ON group_memberships USING btree (student_id);


--
-- Name: index_rubrics_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rubrics_on_category_id ON rubrics USING btree (category_id);


--
-- Name: index_rubrics_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rubrics_on_course_id ON rubrics USING btree (course_id);


--
-- Name: index_submissions_on_assignment_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_submissions_on_assignment_type ON submissions USING btree (assignment_type);


--
-- Name: index_submissions_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_submissions_on_course_id ON submissions USING btree (course_id);


--
-- Name: index_tasks_on_assignment_id_and_assignment_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tasks_on_assignment_id_and_assignment_type ON tasks USING btree (assignment_id, assignment_type);


--
-- Name: index_tasks_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tasks_on_course_id ON tasks USING btree (course_id);


--
-- Name: index_tasks_on_id_and_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tasks_on_id_and_type ON tasks USING btree (id, type);


--
-- Name: index_users_on_kerberos_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_kerberos_uid ON users USING btree (kerberos_uid);


--
-- Name: index_users_on_last_logout_at_and_last_activity_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_last_logout_at_and_last_activity_at ON users USING btree (last_logout_at, last_activity_at);


--
-- Name: index_users_on_remember_me_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_remember_me_token ON users USING btree (remember_me_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_weights_on_student_id_and_assignment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_weights_on_student_id_and_assignment_id ON assignment_weights USING btree (student_id, assignment_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130809194610');

INSERT INTO schema_migrations (version) VALUES ('20130809205352');

INSERT INTO schema_migrations (version) VALUES ('20130814202221');

INSERT INTO schema_migrations (version) VALUES ('20130814202405');

INSERT INTO schema_migrations (version) VALUES ('20130815020310');

INSERT INTO schema_migrations (version) VALUES ('20130815141039');

INSERT INTO schema_migrations (version) VALUES ('20130816154109');

INSERT INTO schema_migrations (version) VALUES ('20130816200137');

INSERT INTO schema_migrations (version) VALUES ('20130816200842');

INSERT INTO schema_migrations (version) VALUES ('20130816210214');

INSERT INTO schema_migrations (version) VALUES ('20130817182322');

INSERT INTO schema_migrations (version) VALUES ('20130818123239');

INSERT INTO schema_migrations (version) VALUES ('20130818123616');

INSERT INTO schema_migrations (version) VALUES ('20130818174523');

INSERT INTO schema_migrations (version) VALUES ('20130818192130');

INSERT INTO schema_migrations (version) VALUES ('20130818214741');

INSERT INTO schema_migrations (version) VALUES ('20130820194918');

INSERT INTO schema_migrations (version) VALUES ('20130820201847');

INSERT INTO schema_migrations (version) VALUES ('20130820202127');

INSERT INTO schema_migrations (version) VALUES ('20130822003705');

INSERT INTO schema_migrations (version) VALUES ('20130822134106');

INSERT INTO schema_migrations (version) VALUES ('20130824175748');

INSERT INTO schema_migrations (version) VALUES ('20130824184813');

INSERT INTO schema_migrations (version) VALUES ('20130824190030');

INSERT INTO schema_migrations (version) VALUES ('20130825015120');

INSERT INTO schema_migrations (version) VALUES ('20130828220339');

INSERT INTO schema_migrations (version) VALUES ('20130828221014');

INSERT INTO schema_migrations (version) VALUES ('20130829003700');

INSERT INTO schema_migrations (version) VALUES ('20130829140308');

INSERT INTO schema_migrations (version) VALUES ('20130829161303');

INSERT INTO schema_migrations (version) VALUES ('20130829200853');

INSERT INTO schema_migrations (version) VALUES ('20130829204938');

INSERT INTO schema_migrations (version) VALUES ('20130829205616');

INSERT INTO schema_migrations (version) VALUES ('20130830164257');

INSERT INTO schema_migrations (version) VALUES ('20130902174553');

INSERT INTO schema_migrations (version) VALUES ('20130903172132');

INSERT INTO schema_migrations (version) VALUES ('20130903231243');

INSERT INTO schema_migrations (version) VALUES ('20130906002826');

INSERT INTO schema_migrations (version) VALUES ('20130906141107');

INSERT INTO schema_migrations (version) VALUES ('20130908052004');

INSERT INTO schema_migrations (version) VALUES ('20130909123552');

INSERT INTO schema_migrations (version) VALUES ('20130909155053');

INSERT INTO schema_migrations (version) VALUES ('20130910160824');

INSERT INTO schema_migrations (version) VALUES ('20130910223912');

INSERT INTO schema_migrations (version) VALUES ('20130910230120');

INSERT INTO schema_migrations (version) VALUES ('20130911022316');

INSERT INTO schema_migrations (version) VALUES ('20130912175935');

INSERT INTO schema_migrations (version) VALUES ('20130912221847');

INSERT INTO schema_migrations (version) VALUES ('20130913215115');

INSERT INTO schema_migrations (version) VALUES ('20130915202020');

INSERT INTO schema_migrations (version) VALUES ('20130915235018');

INSERT INTO schema_migrations (version) VALUES ('20130917175516');

INSERT INTO schema_migrations (version) VALUES ('20130922173058');

INSERT INTO schema_migrations (version) VALUES ('20130923030514');

INSERT INTO schema_migrations (version) VALUES ('20130923152319');

INSERT INTO schema_migrations (version) VALUES ('20130923164329');

INSERT INTO schema_migrations (version) VALUES ('20130923194506');

INSERT INTO schema_migrations (version) VALUES ('20130925173717');

INSERT INTO schema_migrations (version) VALUES ('20130925174641');

INSERT INTO schema_migrations (version) VALUES ('20130925181035');

INSERT INTO schema_migrations (version) VALUES ('20130929185115');

INSERT INTO schema_migrations (version) VALUES ('20130929200510');

INSERT INTO schema_migrations (version) VALUES ('20131005014350');

INSERT INTO schema_migrations (version) VALUES ('20131005031533');

INSERT INTO schema_migrations (version) VALUES ('20131005225544');

INSERT INTO schema_migrations (version) VALUES ('20131009035508');

INSERT INTO schema_migrations (version) VALUES ('20131009035532');

INSERT INTO schema_migrations (version) VALUES ('20131022111426');
