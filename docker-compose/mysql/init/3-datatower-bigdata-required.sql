CREATE DATABASE if not exists `datatower` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT ENCRYPTION='N';
USE datatower;
create table if not exists tb_app_id
(
    id                   int auto_increment
        primary key,
    app_id               varchar(255)                                      not null,
    app_name             varchar(255)                                      not null,
    product_type         enum ('test', 'general') default 'general'         not null,
    ad_revenue_type      int                     default 3                 null comment '2: earnings
3: earnings_cy
4: earnings_cy_proxy',
    ad_impression_type   int                     default 1                 null,
    status               int                     default 0                 null comment '',
    firebase_token       varchar(255)                                      null,
    event_limit          int                     default 500               not null,
    event_property_limit int                     default 300               not null,
    user_property_limit  int                     default 300               not null,
    user_system_type     int                     default 2                 null,
    company_id           int                                               not null,
    time_zone_offset     int                     default 0                 null,
    deleted              int                                               null,
    event_used           bigint                  default 0                 null,
    inserttime           timestamp               default CURRENT_TIMESTAMP not null,
    updatetime           timestamp               default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    ltv_period           int                     default 30                not null comment '',
    access_status        tinyint                 default 0                 not null comment '',
    hash                 int                                               null,
    access_version       enum ('Free', 'Pro')                              null,
    package_name         varchar(255)                                      null,
    app_platform         varchar(255)                                      null,
    access_step          tinyint                 default 0                 null,
    s2s_token            char(32)                                          null,
    js_token             char(16)                                          null,
    ranger_policy        text                                              null,
    notification_status  int                     default 0                 null,
    notification_users   text                                              null
);

create table if not exists tb_bury_basic_event_property
(
    id           bigint auto_increment
        primary key,
    app_id       varchar(20)                                                                                not null comment '',
    name         varchar(128)                                                                               not null comment '',
    display_name varchar(256)                                                                               null comment '',
    `describe`   varchar(1024) default ''                                                                   null comment '',
    type         enum ('number', 'string', 'date', 'array', 'boolean', 'dateTime', 'object', 'objectArray') not null,
    create_time  timestamp     default CURRENT_TIMESTAMP                                                    not null,
    update_time  timestamp     default CURRENT_TIMESTAMP                                                    not null on update CURRENT_TIMESTAMP,
    constraint udx1
        unique (app_id, name)
)
    row_format = DYNAMIC;

create index udx2
    on tb_bury_basic_event_property (app_id);

create table if not exists tb_bury_config
(
    id         int auto_increment
        primary key,
    app_id     varchar(20)                                        not null comment '',
    mode       enum ('free', 'strong', 'custom') default 'custom' null,
    event      tinyint                           default 1        not null comment '',
    event_prop tinyint                           default 1        not null comment '',
    user_prop  tinyint                           default 1        not null comment '',
    prop_type  tinyint                           default 1        not null comment '',
    constraint udx1
        unique (app_id)
)
    row_format = DYNAMIC;

create index udx2
    on tb_bury_config (app_id);

create table if not exists tb_bury_event
(
    id           int auto_increment
        primary key,
    app_id       varchar(20)                         not null comment '',
    name         varchar(128)                        not null comment '',
    display_name varchar(255)                        null comment '',
    `describe`   text                                null comment '',
    event_tag    text                                null comment '',
    has_reported tinyint   default 0                 not null comment '',
    create_user  int                                 not null comment '',
    update_user  int                                 not null comment '',
    deleted      tinyint   default 0                 not null comment '',
    create_time  timestamp default CURRENT_TIMESTAMP not null,
    update_time  timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint udx1
        unique (app_id, name)
)
    row_format = DYNAMIC;

create index udx2
    on tb_bury_event (app_id);

create table if not exists tb_bury_event_property
(
    id           bigint auto_increment
        primary key,
    app_id       varchar(20)       not null comment '',
    name         varchar(128)      not null comment '',
    event_name   varchar(128)      not null comment '',
    has_reported tinyint default 0 not null comment '',
    deleted      tinyint default 0 not null comment '',
    constraint udx1
        unique (app_id, name, event_name)
)
    row_format = DYNAMIC;

create index udx2
    on tb_bury_event_property (app_id);

create index udx3
    on tb_bury_event_property (event_name);

create table if not exists tb_bury_user_property
(
    id           bigint auto_increment
        primary key,
    app_id       varchar(20)                                                                                not null comment '',
    name         varchar(128)                                                                               not null comment '',
    display_name varchar(256)                                                                               null comment '',
    `describe`   varchar(1024) default ''                                                                   null comment '',
    type         enum ('number', 'string', 'date', 'array', 'boolean', 'dateTime', 'object', 'objectArray') not null,
    update_type  enum ('user_set', 'user_add', 'user_set_once', 'user_append')                              null,
    has_reported tinyint       default 0                                                                    not null comment '',
    property_tag text                                                                                       null comment '',
    create_user  int                                                                                        not null comment '',
    update_user  int                                                                                        not null comment '',
    deleted      tinyint       default 0                                                                    not null comment '',
    create_time  timestamp     default CURRENT_TIMESTAMP                                                    not null,
    update_time  timestamp     default CURRENT_TIMESTAMP                                                    not null on update CURRENT_TIMESTAMP,
    constraint udx1
        unique (app_id, name)
)
    row_format = DYNAMIC;

create index udx2
    on tb_bury_user_property (app_id);

create table if not exists tb_company
(
    id                    int auto_increment
        primary key,
    name                  varchar(255)                        not null,
    app_limit             int       default 5                 null,
    event_limit           int       default 150000000         null,
    meta_event_limit      int       default 500               null,
    event_property_limit  int       default 300               null,
    user_property_limit   int       default 300               null,
    start_service         datetime  default CURRENT_TIMESTAMP null,
    stop_service          datetime                            null,
    inserttime            timestamp default CURRENT_TIMESTAMP not null,
    updatetime            timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    report_url            varchar(255)                        null,
    access_version        enum ('Free', 'Pro')                null,
    csp                   varchar(100)                        null,
    billing_name          varchar(256)                        null,
    billing_method        enum ('prepaid', 'postpaid')        null,
    billing_period        enum ('year', 'month')              null,
    contain_preset_events tinyint(1)                          null,
    billing_event_count   bigint                              null,
    billing_start_time    timestamp                           null,
    billing_end_time      timestamp                           null,
    billing_mau           int                                 null
);

create table if not exists tb_debugging_data
(
    id                    int auto_increment
        primary key,
    app_id                varchar(255)                       not null comment '',
    did                   varchar(255)                       not null comment '',
    event_name            varchar(255)                       not null comment '',
    event_time            datetime                           not null comment '',
    datain_result         enum ('0', '1', '2')               not null comment '',
    datain_failing_reason varchar(255)                       null comment '',
    data                  json                               not null comment '',
    inserttime            datetime default CURRENT_TIMESTAMP not null,
    updatetime            datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
);

create table if not exists tb_debugging_device
(
    id          int auto_increment
        primary key,
    app_id      varchar(255)                       not null comment '',
    device_id   varchar(255)                       not null comment '',
    device_name varchar(255)                       not null comment '',
    inserttime  datetime default CURRENT_TIMESTAMP not null,
    updatetime  datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint `device-pk`
        unique (app_id, device_id)
);

create table if not exists tb_event_meta
(
    id           int auto_increment
        primary key,
    app_id       varchar(64)                             not null comment '',
    event_name   varchar(64)                             not null comment '',
    event_desc   varchar(255)  default ''                null comment '',
    type         tinyint       default 0                 not null comment '',
    status       tinyint       default 1                 not null comment '',
    is_hide      tinyint       default 0                 not null comment '',
    remark       varchar(1024) default ''                not null comment '',
    with_update  tinyint       default 0                 not null comment '',
    create_time  timestamp     default CURRENT_TIMESTAMP not null,
    update_time  timestamp     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    display_name varchar(255)                            null comment '',
    paradigm     text                                    null,
    is_default   tinyint       default 0                 null comment '',
    constraint udx1
        unique (app_id, event_name)
);

create table if not exists tb_event_property
(
    id          int auto_increment
        primary key,
    event_id    int                                  not null,
    is_hide     tinyint(1) default 0                 null,
    property_id int                                  not null,
    insert_time timestamp  default CURRENT_TIMESTAMP not null,
    update_time timestamp  default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint udx1
        unique (event_id, property_id)
);

create table if not exists tb_param_data
(
    id          int auto_increment
        primary key,
    app_id      varchar(30) charset utf8mb4                                                                                                                                                      not null,
    param_type  enum ('#ad_location', '#ad_id', '#app_version_name', '#iap_sku', '#ias_sku', '#os_lang', '#device_brand', '#device_model', '#app_version_code', '#os_lang_code') charset utf8mb4 not null comment '',
    param_value varchar(255) charset utf8mb4                                                                                                                                                     not null,
    constraint `app_id+param_type+param_value`
        unique (app_id, param_type, param_value) comment ''
);

create table if not exists tb_preset_event
(
    id           int auto_increment
        primary key,
    event_name   varchar(64)                             not null comment '',
    event_desc   varchar(255)  default ''                null comment '',
    remark       varchar(1024) default ''                not null comment '',
    with_update  tinyint       default 0                 not null comment '',
    insert_time  timestamp     default CURRENT_TIMESTAMP not null,
    update_time  timestamp     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    display_name varchar(255)                            null,
    constraint event_name
        unique (event_name)
);

create table if not exists tb_preset_property
(
    id                 int auto_increment comment ''
        primary key,
    table_type         int                                              not null comment '',
    property_name      varchar(128)                                     not null comment '',
    column_name        varchar(128)                                     not null comment '',
    column_type        varchar(64)                                      not null comment '',
    column_desc        varchar(1024)                                    null comment '',
    display_name       varchar(256)                                     null comment '',
    select_type        enum ('number', 'string', 'boolean', 'dateTime') null comment '',
    is_hide            tinyint(1) default 0                             not null comment '',
    is_system_property tinyint(1) default 0                             not null comment '',
    create_time        timestamp  default CURRENT_TIMESTAMP             not null,
    update_time        timestamp  default CURRENT_TIMESTAMP             not null,
    constraint column_name_unique_index
        unique (table_type, column_name),
    constraint id
        unique (id)
);

create table if not exists tb_property_meta
(
    id                    bigint auto_increment
        primary key,
    app_id                varchar(128)                                                                                                                                not null comment '',
    table_type            int                                                                                                                                         not null comment '',
    column_index          int                                                                                                                                         not null comment '',
    column_name           varchar(64)                                                                                                                                 not null comment '',
    column_type           enum ('integer', 'bigint', 'real', 'double', 'varchar', 'boolean', 'timestamp', 'decimal', 'array(varchar)', 'row', 'array(row)', 'string') not null,
    column_desc           varchar(1024) default ''                                                                                                                    null comment '',
    display_name          varchar(256)                                                                                                                                null comment '',
    unit                  varchar(64)   default ''                                                                                                                    not null comment '',
    select_type           enum ('number', 'string', 'date', 'array', 'boolean', 'dateTime', 'object', 'objectArray')                                                  not null,
    type                  int           default 0                                                                                                                     null comment '',
    status                tinyint(1)    default 1                                                                                                                     not null comment '',
    is_hide               tinyint(1)    default 0                                                                                                                     not null comment '',
    has_dict              tinyint(1)    default 0                                                                                                                     null comment '',
    timestamp_join_format varchar(24)                                                                                                                                 null comment '',
    is_init_column        tinyint(1)    default 0                                                                                                                     null comment '',
    create_time           timestamp     default CURRENT_TIMESTAMP                                                                                                     not null,
    update_time           timestamp     default CURRENT_TIMESTAMP                                                                                                     not null on update CURRENT_TIMESTAMP,
    has_dimension         tinyint       default 0                                                                                                                     not null comment '',
    constraint udx1
        unique (app_id, table_type, column_name),
    constraint udx2
        unique (app_id, table_type, column_index)
);

create table if not exists tb_property_sub_meta
(
    id                    bigint auto_increment
        primary key,
    app_id                varchar(128)                                                                                                 not null comment '',
    table_type            int                                                                                                          not null comment '',
    parent_id             bigint                                                                                                       not null comment '',
    parent_column_name    varchar(64)                                                                                                  not null comment '',
    column_name           varchar(64)                                                                                                  not null comment '',
    column_index          int                                                                                                          not null comment '',
    column_type           enum ('integer', 'bigint', 'real', 'double', 'varchar', 'boolean', 'timestamp', 'decimal', 'array(varchar)') not null comment '',
    column_desc           varchar(1024) default ''                                                                                     null comment '',
    display_name          varchar(256)                                                                                                 null comment '',
    unit                  varchar(64)   default ''                                                                                     not null comment '',
    select_type           enum ('number', 'string', 'date', 'array', 'boolean', 'dateTime')                                            null,
    is_hide               tinyint(1)    default 0                                                                                      not null comment '',
    timestamp_join_format varchar(24)                                                                                                  null comment '',
    create_time           timestamp     default CURRENT_TIMESTAMP                                                                      not null,
    update_time           timestamp     default CURRENT_TIMESTAMP                                                                      not null on update CURRENT_TIMESTAMP,
    has_dimension         tinyint(1)    default 0                                                                                      not null comment '',
    constraint udx1
        unique (app_id, table_type, parent_column_name, column_name),
    constraint udx2
        unique (app_id, table_type, parent_id, column_name),
    constraint udx3
        unique (app_id, table_type, parent_id, column_index)
);
