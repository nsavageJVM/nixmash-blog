
-- ------------------------------------------------------------------------------------
-- BEGIN SPRING BATCH FROM FRAMEWORK
-- ------------------------------------------------------------------------------------

CREATE TABLE batch_job_instance
(
  JOB_INSTANCE_ID BIGINT(20) PRIMARY KEY NOT NULL,
  VERSION BIGINT(20),
  JOB_NAME VARCHAR(100) NOT NULL,
  JOB_KEY VARCHAR(32) NOT NULL
);
CREATE UNIQUE INDEX JOB_INST_UN ON batch_job_instance (JOB_NAME, JOB_KEY);
CREATE TABLE batch_job_execution
(
  JOB_EXECUTION_ID BIGINT(20) PRIMARY KEY NOT NULL,
  VERSION BIGINT(20),
  JOB_INSTANCE_ID BIGINT(20) NOT NULL,
  CREATE_TIME DATETIME NOT NULL,
  START_TIME DATETIME,
  END_TIME DATETIME,
  STATUS VARCHAR(10),
  EXIT_CODE VARCHAR(2500),
  EXIT_MESSAGE VARCHAR(2500),
  LAST_UPDATED DATETIME,
  JOB_CONFIGURATION_LOCATION VARCHAR(2500),
  CONSTRAINT JOB_INST_EXEC_FK FOREIGN KEY (JOB_INSTANCE_ID) REFERENCES batch_job_instance (JOB_INSTANCE_ID)
);
CREATE INDEX JOB_INST_EXEC_FK ON batch_job_execution (JOB_INSTANCE_ID);
CREATE TABLE batch_job_execution_context
(
  JOB_EXECUTION_ID BIGINT(20) PRIMARY KEY NOT NULL,
  SHORT_CONTEXT VARCHAR(2500) NOT NULL,
  SERIALIZED_CONTEXT TEXT,
  CONSTRAINT JOB_EXEC_CTX_FK FOREIGN KEY (JOB_EXECUTION_ID) REFERENCES batch_job_execution (JOB_EXECUTION_ID)
);
CREATE TABLE batch_job_execution_params
(
  JOB_EXECUTION_ID BIGINT(20) NOT NULL,
  TYPE_CD VARCHAR(6) NOT NULL,
  KEY_NAME VARCHAR(100) NOT NULL,
  STRING_VAL VARCHAR(250),
  DATE_VAL DATETIME,
  LONG_VAL BIGINT(20),
  DOUBLE_VAL DOUBLE,
  IDENTIFYING CHAR(1) NOT NULL,
  CONSTRAINT JOB_EXEC_PARAMS_FK FOREIGN KEY (JOB_EXECUTION_ID) REFERENCES batch_job_execution (JOB_EXECUTION_ID)
);
CREATE INDEX JOB_EXEC_PARAMS_FK ON batch_job_execution_params (JOB_EXECUTION_ID);
CREATE TABLE batch_job_execution_seq
(
  ID BIGINT(20) NOT NULL,
  UNIQUE_KEY CHAR(1) NOT NULL
);
CREATE UNIQUE INDEX UNIQUE_KEY_UN ON batch_job_execution_seq (UNIQUE_KEY);


CREATE TABLE batch_job_seq
(
  ID BIGINT(20) NOT NULL,
  UNIQUE_KEY CHAR(1) NOT NULL
);
CREATE UNIQUE INDEX UNIQUE_KEY_UN ON batch_job_seq (UNIQUE_KEY);
CREATE TABLE batch_step_execution
(
  STEP_EXECUTION_ID BIGINT(20) PRIMARY KEY NOT NULL,
  VERSION BIGINT(20) NOT NULL,
  STEP_NAME VARCHAR(100) NOT NULL,
  JOB_EXECUTION_ID BIGINT(20) NOT NULL,
  START_TIME DATETIME NOT NULL,
  END_TIME DATETIME,
  STATUS VARCHAR(10),
  COMMIT_COUNT BIGINT(20),
  READ_COUNT BIGINT(20),
  FILTER_COUNT BIGINT(20),
  WRITE_COUNT BIGINT(20),
  READ_SKIP_COUNT BIGINT(20),
  WRITE_SKIP_COUNT BIGINT(20),
  PROCESS_SKIP_COUNT BIGINT(20),
  ROLLBACK_COUNT BIGINT(20),
  EXIT_CODE VARCHAR(2500),
  EXIT_MESSAGE VARCHAR(2500),
  LAST_UPDATED DATETIME,
  CONSTRAINT JOB_EXEC_STEP_FK FOREIGN KEY (JOB_EXECUTION_ID) REFERENCES batch_job_execution (JOB_EXECUTION_ID)
);
CREATE INDEX JOB_EXEC_STEP_FK ON batch_step_execution (JOB_EXECUTION_ID);
CREATE TABLE batch_step_execution_context
(
  STEP_EXECUTION_ID BIGINT(20) PRIMARY KEY NOT NULL,
  SHORT_CONTEXT VARCHAR(2500) NOT NULL,
  SERIALIZED_CONTEXT TEXT,
  CONSTRAINT STEP_EXEC_CTX_FK FOREIGN KEY (STEP_EXECUTION_ID) REFERENCES batch_step_execution (STEP_EXECUTION_ID)
);
CREATE TABLE batch_step_execution_seq
(
  ID BIGINT(20) NOT NULL,
  UNIQUE_KEY CHAR(1) NOT NULL
);
CREATE UNIQUE INDEX UNIQUE_KEY_UN ON batch_step_execution_seq (UNIQUE_KEY);

-- ------------------------------------------------------------------------------------
-- END SPRING BATCH FROM FRAMEWORK
-- ------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------
-- Batch View for BatchJob Reports
-- ------------------------------------------------------------------------------------

CREATE VIEW v_batch_job_report AS
  SELECT
    batch_job_execution.JOB_INSTANCE_ID AS JOB_INSTANCE_ID,
    batch_job_instance.JOB_NAME         AS JOB_NAME,
    batch_job_execution.START_TIME      AS START_TIME,
    batch_job_execution.END_TIME        AS END_TIME,
    batch_job_execution.STATUS          AS STATUS,
    batch_job_execution.EXIT_CODE       AS EXIT_CODE,
    batch_job_execution.EXIT_MESSAGE    AS EXIT_MESSAGE
  FROM (batch_job_execution
    JOIN batch_job_instance ON ((batch_job_execution.JOB_INSTANCE_ID =
                                 batch_job_instance.JOB_INSTANCE_ID)));