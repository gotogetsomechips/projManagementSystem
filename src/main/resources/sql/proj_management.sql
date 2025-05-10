/*
 Navicat Premium Dump SQL

 Source Server         : yuzhouchen
 Source Server Type    : MySQL
 Source Server Version : 80300 (8.3.0)
 Source Host           : localhost:3306
 Source Schema         : proj_management

 Target Server Type    : MySQL
 Target Server Version : 80300 (8.3.0)
 File Encoding         : 65001

 Date: 09/05/2025 01:58:13
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_message
-- ----------------------------
DROP TABLE IF EXISTS `sys_message`;
CREATE TABLE `sys_message`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息标题',
  `sender` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '发送人',
  `receiver` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接收人',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '消息内容',
  `send_time` datetime NOT NULL COMMENT '发送时间',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态(0:未读,1:已读)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_receiver`(`receiver` ASC) USING BTREE,
  INDEX `idx_send_time`(`send_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统消息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_message
-- ----------------------------
INSERT INTO `sys_message` VALUES (1, '项目进度通知', 'admin', 'user1', '请尽快完成项目第一阶段工作', '2023-06-01 09:00:00', 1, '2023-06-01 09:00:00', '2023-06-01 10:00:00', 'admin', 'user1');
INSERT INTO `sys_message` VALUES (2, '会议提醒', 'manager', 'user2', '下午3点会议室A开会', '2023-06-02 10:30:00', 0, '2023-06-02 10:30:00', NULL, 'manager', NULL);
INSERT INTO `sys_message` VALUES (3, '系统升级通知', 'admin', 'all', '系统将于今晚12点进行升级维护', '2023-06-03 15:00:00', 1, '2023-06-03 15:00:00', '2023-06-03 18:00:00', 'admin', 'system');
INSERT INTO `sys_message` VALUES (4, '任务分配', 'leader', 'user3', '你被分配到新项目开发任务', '2023-06-04 11:20:00', 0, '2023-06-04 11:20:00', NULL, 'leader', NULL);
INSERT INTO `sys_message` VALUES (5, '请假审批结果', 'hr', 'user4', '你的请假申请已批准', '2023-06-05 14:15:00', 1, '2023-06-05 14:15:00', '2023-06-05 16:30:00', 'hr', 'user4');
INSERT INTO `sys_message` VALUES (6, '工作报告提交', 'manager', 'user5', '请在周五前提交本周工作报告', '2023-06-06 09:10:00', 0, '2023-06-06 09:10:00', NULL, 'manager', NULL);
INSERT INTO `sys_message` VALUES (7, '培训通知', 'hr', 'all', '公司将于下周三举办安全培训', '2023-06-06 10:30:00', 1, '2023-06-06 10:30:00', '2023-06-06 14:00:00', 'hr', 'system');
INSERT INTO `sys_message` VALUES (8, '项目反馈', 'client1', 'user2', '对于项目初期成果表示满意，期待后续进展', '2023-06-07 13:25:00', 0, '2023-06-07 13:25:00', NULL, 'client1', NULL);
INSERT INTO `sys_message` VALUES (9, '系统Bug修复', 'user6', 'dev_team', '登录页面存在安全漏洞，请尽快修复', '2023-06-07 16:40:00', 1, '2023-06-07 16:40:00', '2023-06-07 17:15:00', 'user6', 'dev_lead');
INSERT INTO `sys_message` VALUES (10, '加班申请', 'user7', 'hr', '本周六需要加班完成项目收尾工作', '2023-06-08 11:05:00', 0, '2023-06-08 11:05:00', NULL, 'user7', NULL);
INSERT INTO `sys_message` VALUES (11, '设备报修', 'user8', 'it_support', '办公室打印机出现故障，无法正常使用', '2023-06-08 14:30:00', 1, '2023-06-08 14:30:00', '2023-06-08 15:20:00', 'user8', 'it_staff');
INSERT INTO `sys_message` VALUES (12, '客户沟通会议', 'sales', 'user9', '明天上午10点与客户进行视频会议', '2023-06-09 09:00:00', 0, '2023-06-09 09:00:00', NULL, 'sales', NULL);
INSERT INTO `sys_message` VALUES (13, '季度绩效评估', 'hr', 'all', '下周开始进行Q2季度绩效评估', '2023-06-09 13:15:00', 1, '2023-06-09 13:15:00', '2023-06-09 14:00:00', 'hr', 'system');
INSERT INTO `sys_message` VALUES (14, '项目延期提醒', 'pm', 'dev_team', '由于资源调整，项目交付日期延后一周', '2023-06-10 10:30:00', 0, '2023-06-10 10:30:00', NULL, 'pm', NULL);
INSERT INTO `sys_message` VALUES (15, '文档更新', 'user10', 'user3', '产品说明文档已更新，请查看最新版本', '2023-06-10 15:45:00', 1, '2023-06-10 15:45:00', '2023-06-10 16:30:00', 'user10', 'user3');
INSERT INTO `sys_message` VALUES (16, '办公用品申请', 'user11', 'admin', '申请补充办公室文具用品', '2023-06-11 09:20:00', 0, '2023-06-11 09:20:00', NULL, 'user11', NULL);
INSERT INTO `sys_message` VALUES (17, '系统权限变更', 'admin', 'user12', '你的系统权限已升级为高级管理员', '2023-06-11 11:30:00', 1, '2023-06-11 11:30:00', '2023-06-11 14:00:00', 'admin', 'user12');
INSERT INTO `sys_message` VALUES (18, '出差报销', 'finance', 'user13', '你的出差报销已通过审核', '2023-06-12 10:15:00', 0, '2023-06-12 10:15:00', NULL, 'finance', NULL);
INSERT INTO `sys_message` VALUES (19, '团队建设活动', 'hr', 'all', '本月团队建设活动将于25日举行', '2023-06-12 13:40:00', 1, '2023-06-12 13:40:00', '2023-06-12 15:00:00', 'hr', 'system');
INSERT INTO `sys_message` VALUES (20, '代码审查', 'dev_lead', 'user14', '请对新提交的代码进行审查', '2023-06-13 09:50:00', 0, '2023-06-13 09:50:00', NULL, 'dev_lead', NULL);
INSERT INTO `sys_message` VALUES (21, '客户投诉处理', 'support', 'sales_team', '客户反馈产品存在功能缺陷，请跟进处理', '2023-06-13 14:25:00', 1, '2023-06-13 14:25:00', '2023-06-13 16:00:00', 'support', 'sales_manager');
INSERT INTO `sys_message` VALUES (22, '年假申请', 'user15', 'hr', '申请下个月休年假五天', '2023-06-14 10:00:00', 0, '2023-06-14 10:00:00', NULL, 'user15', NULL);
INSERT INTO `sys_message` VALUES (23, '项目验收通知', 'pm', 'dev_team', '项目将于下周一进行最终验收', '2023-06-14 15:30:00', 1, '2023-06-14 15:30:00', '2023-06-14 16:45:00', 'pm', 'dev_lead');
INSERT INTO `sys_message` VALUES (24, '薪资调整通知', 'hr', 'user16', '根据绩效评估，你的薪资将进行调整', '2023-06-15 09:30:00', 0, '2023-06-15 09:30:00', NULL, 'hr', NULL);
INSERT INTO `sys_message` VALUES (25, '安全漏洞警告', 'security', 'all', '发现重要安全漏洞，请立即更新密码', '2023-06-15 13:00:00', 1, '2023-06-15 13:00:00', '2023-06-15 14:30:00', 'security', 'system');
INSERT INTO `sys_message` VALUES (26, '服务器维护通知', 'it', 'all', '服务器将于本周六进行维护升级', '2023-06-16 10:20:00', 0, '2023-06-16 10:20:00', NULL, 'it', NULL);
INSERT INTO `sys_message` VALUES (27, '新员工入职', 'hr', 'team_leaders', '新员工将于下周一入职，请做好准备', '2023-06-16 14:45:00', 1, '2023-06-16 14:45:00', '2023-06-16 16:00:00', 'hr', 'team_leader1');
INSERT INTO `sys_message` VALUES (28, '市场调研报告', 'marketing', 'management', '本季度市场调研报告已完成', '2023-06-17 09:15:00', 0, '2023-06-17 09:15:00', NULL, 'marketing', NULL);
INSERT INTO `sys_message` VALUES (29, '产品更新计划', 'product_manager', 'dev_team', '产品将进行重大更新，详情见附件', '2023-06-17 13:50:00', 1, '2023-06-17 13:50:00', '2023-06-17 15:30:00', 'product_manager', 'dev_lead');
INSERT INTO `sys_message` VALUES (30, '网络故障通知', 'it', 'all', '办公网络出现故障，正在抢修中', '2023-06-18 08:30:00', 0, '2023-06-18 08:30:00', NULL, 'it', NULL);
INSERT INTO `sys_message` VALUES (31, '合同审核', 'legal', 'user17', '请协助审核新客户合同条款', '2023-06-18 11:45:00', 1, '2023-06-18 11:45:00', '2023-06-18 14:20:00', 'legal', 'user17');
INSERT INTO `sys_message` VALUES (32, '知识库更新', 'admin', 'all', '公司知识库已更新，新增多项技术文档', '2023-06-19 09:40:00', 0, '2023-06-19 09:40:00', NULL, 'admin', NULL);
INSERT INTO `sys_message` VALUES (33, '员工福利调整', 'hr', 'all', '公司将调整员工福利政策，详情见附件', '2023-06-19 14:00:00', 1, '2023-06-19 14:00:00', '2023-06-19 15:30:00', 'hr', 'system');
INSERT INTO `sys_message` VALUES (34, '项目状态报告', 'pm', 'management', '各项目进展状态汇总报告', '2023-06-20 10:10:00', 0, '2023-06-20 10:10:00', NULL, 'pm', NULL);
INSERT INTO `sys_message` VALUES (35, '办公室搬迁通知', 'admin', 'all', '公司将于下月搬迁至新办公地点', '2023-06-20 15:20:00', 1, '2023-06-20 15:20:00', '2023-06-20 16:45:00', 'admin', 'system');
INSERT INTO `sys_message` VALUES (36, '技术分享会', 'dev_lead', 'dev_team', '本周五下午技术分享会，主题：微服务架构', '2023-06-21 09:30:00', 0, '2023-06-21 09:30:00', NULL, 'dev_lead', NULL);
INSERT INTO `sys_message` VALUES (37, '客户满意度调查', 'marketing', 'all', '请协助完成客户满意度季度调查', '2023-06-21 13:40:00', 1, '2023-06-21 13:40:00', '2023-06-21 15:00:00', 'marketing', 'system');
INSERT INTO `sys_message` VALUES (38, '模块测试通知', 'qa', 'dev_team', '新模块测试已完成，存在部分问题需修复', '2023-06-22 10:25:00', 0, '2023-06-22 10:25:00', NULL, 'qa', NULL);
INSERT INTO `sys_message` VALUES (39, '预算审核', 'finance', 'department_heads', '请提交下半年部门预算计划', '2023-06-22 14:50:00', 1, '2023-06-22 14:50:00', '2023-06-22 16:30:00', 'finance', 'department_head1');
INSERT INTO `sys_message` VALUES (40, 'UI设计稿评审', 'designer', 'dev_team', '新版UI设计稿已上传，请参与评审', '2023-06-23 09:20:00', 0, '2023-06-23 09:20:00', NULL, 'designer', NULL);
INSERT INTO `sys_message` VALUES (41, '软件许可证更新', 'it', 'dev_team', '开发工具许可证即将到期，准备更新', '2023-06-23 13:35:00', 1, '2023-06-23 13:35:00', '2023-06-23 15:10:00', 'it', 'dev_lead');
INSERT INTO `sys_message` VALUES (42, '销售目标完成情况', 'sales_manager', 'sales_team', '本月销售目标完成情况汇总', '2023-06-24 10:00:00', 0, '2023-06-24 10:00:00', NULL, 'sales_manager', NULL);
INSERT INTO `sys_message` VALUES (43, '数据备份提醒', 'it', 'all', '请各部门做好重要数据备份工作', '2023-06-24 15:15:00', 1, '2023-06-24 15:15:00', '2023-06-24 16:40:00', 'it', 'system');
INSERT INTO `sys_message` VALUES (44, '月度工作总结', 'manager', 'team_members', '请准备本月工作总结报告', '2023-06-25 09:45:00', 0, '2023-06-25 09:45:00', NULL, 'manager', NULL);
INSERT INTO `sys_message` VALUES (45, '系统账号审计', 'security', 'all', '进行系统账号安全审计，请更新密码', '2023-06-25 14:30:00', 1, '2023-06-25 14:30:00', '2023-06-25 16:00:00', 'security', 'system');
INSERT INTO `sys_message` VALUES (46, '项目交付确认', 'pm', 'client2', '项目已完成开发，请确认交付内容', '2023-06-26 10:40:00', 0, '2023-06-26 10:40:00', NULL, 'pm', NULL);
INSERT INTO `sys_message` VALUES (47, '面试安排', 'hr', 'interviewer1', '请协助参与下周三的面试工作', '2023-06-26 15:00:00', 1, '2023-06-26 15:00:00', '2023-06-26 16:30:00', 'hr', 'interviewer1');
INSERT INTO `sys_message` VALUES (48, '绩效面谈安排', 'hr', 'user18', '你的绩效面谈安排在下周一下午2点', '2023-06-27 09:10:00', 0, '2023-06-27 09:10:00', NULL, 'hr', NULL);
INSERT INTO `sys_message` VALUES (49, '需求变更通知', 'product_manager', 'dev_team', '客户需求有重大变更，请注意调整', '2023-06-27 13:20:00', 1, '2023-06-27 13:20:00', '2023-06-27 15:45:00', 'product_manager', 'dev_lead');
INSERT INTO `sys_message` VALUES (50, '软件升级通知', 'it', 'all', '办公软件将进行升级，请做好准备', '2023-06-28 10:30:00', 0, '2023-06-28 10:30:00', NULL, 'it', NULL);
INSERT INTO `sys_message` VALUES (51, '项目验收结果', 'client3', 'pm', '项目验收通过，感谢团队的努力', '2023-06-28 14:45:00', 1, '2023-06-28 14:45:00', '2023-06-28 16:15:00', 'client3', 'pm');
INSERT INTO `sys_message` VALUES (52, '假期安排', 'hr', 'all', '国庆节放假安排已出，请查看', '2023-06-29 09:25:00', 0, '2023-06-29 09:25:00', NULL, 'hr', NULL);
INSERT INTO `sys_message` VALUES (53, '社保缴纳确认', 'finance', 'all', '本月社保缴纳已完成，请确认', '2023-06-29 13:50:00', 1, '2023-06-29 13:50:00', '2023-06-29 15:20:00', 'finance', 'system');
INSERT INTO `sys_message` VALUES (54, '客户回访通知', 'sales', 'user19', '请安排对重点客户进行回访', '2023-06-30 10:15:00', 0, '2023-06-30 10:15:00', NULL, 'sales', NULL);
INSERT INTO `sys_message` VALUES (55, '业务流程优化', 'operation', 'all', '公司将进行业务流程优化，请积极配合', '2023-06-30 14:30:00', 1, '2023-06-30 14:30:00', '2023-06-30 16:00:00', 'operation', 'system');
INSERT INTO `sys_message` VALUES (56, '专利申请进展', 'legal', 'rd_team', '公司专利申请已获初步审核通过', '2023-07-01 09:40:00', 0, '2023-07-01 09:40:00', NULL, 'legal', NULL);
INSERT INTO `sys_message` VALUES (57, '项目启动会议', 'pm', 'project_team', '新项目启动会议将于明天上午9点举行', '2023-07-01 13:30:00', 1, '2023-07-01 13:30:00', '2023-07-01 15:40:00', 'pm', 'project_lead');
INSERT INTO `sys_message` VALUES (58, '数据分析报告', 'analyst', 'management', '用户行为数据分析报告已完成', '2023-07-02 10:20:00', 0, '2023-07-02 10:20:00', NULL, 'analyst', NULL);
INSERT INTO `sys_message` VALUES (59, '设备更新计划', 'it', 'all', '公司将分批更新办公设备，请查看时间表', '2023-07-02 14:10:00', 1, '2023-07-02 14:10:00', '2023-07-02 16:20:00', 'it', 'system');
INSERT INTO `sys_message` VALUES (60, '客户投诉反馈', 'support', 'product_team', '客户反馈产品存在使用问题，请评估', '2023-07-03 09:15:00', 0, '2023-07-03 09:15:00', NULL, 'support', NULL);
INSERT INTO `sys_message` VALUES (61, '安全生产月活动', 'admin', 'all', '安全生产月系列活动安排', '2023-07-03 13:45:00', 1, '2023-07-03 13:45:00', '2023-07-03 15:30:00', 'admin', 'system');
INSERT INTO `sys_message` VALUES (62, '系统测试邀请', 'qa', 'user20', '邀请参与新系统功能测试', '2023-07-04 10:35:00', 0, '2023-07-04 10:35:00', NULL, 'qa', NULL);
INSERT INTO `sys_message` VALUES (63, '绩效奖金发放', 'finance', 'all', '上季度绩效奖金将于本周发放', '2023-07-04 14:50:00', 1, '2023-07-04 14:50:00', '2023-07-04 16:10:00', 'finance', 'system');
INSERT INTO `sys_message` VALUES (64, '文档翻译需求', 'international', 'translator', '产品手册需翻译成英文版本', '2023-07-05 09:50:00', 0, '2023-07-05 09:50:00', NULL, 'international', NULL);
INSERT INTO `sys_message` VALUES (65, '培训课程反馈1', 'hr', 'all', '请填写上周培训课程反馈问卷', '2023-07-05 14:20:00', 1, '2023-07-05 14:20:00', '2025-05-09 01:28:49', 'hr', 'system');
INSERT INTO `sys_message` VALUES (66, '文档翻译需求', '123', '123', '12', '2025-05-09 01:30:05', NULL, '2025-05-09 01:30:04', '2025-05-09 01:30:04', 'admin', NULL);
INSERT INTO `sys_message` VALUES (69, '1231', '123', '123', '1', '2025-05-09 01:57:03', NULL, '2025-05-09 01:57:03', '2025-05-09 01:57:03', 'admin', NULL);

-- ----------------------------
-- Table structure for sys_salary
-- ----------------------------
DROP TABLE IF EXISTS `sys_salary`;
CREATE TABLE `sys_salary`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '薪资ID',
  `employee_id` int NULL DEFAULT NULL COMMENT '员工ID',
  `employee_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '员工姓名',
  `year` int NOT NULL COMMENT '年份',
  `month` int NOT NULL COMMENT '月份',
  `base_salary` decimal(10, 2) NOT NULL COMMENT '基本工资',
  `bonus` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '奖金',
  `deduction` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '扣款',
  `total_salary` decimal(10, 2) NOT NULL COMMENT '应发工资',
  `actual_salary` decimal(10, 2) NOT NULL COMMENT '实发工资',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态(0:未发放,1:已发放)',
  `payment_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发放人',
  `payment_time` datetime NULL DEFAULT NULL COMMENT '发放时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_employee_year_month`(`employee_id` ASC, `year` ASC, `month` ASC) USING BTREE COMMENT '员工年月唯一索引'
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '员工薪资表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_salary
-- ----------------------------
INSERT INTO `sys_salary` VALUES (1, 1, '张三', 2023, 1, 8000.00, 1000.00, 500.00, 9000.00, 8500.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:00:31', '2025-05-08 20:00:31', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (2, 2, '李四', 2023, 1, 7500.00, 800.00, 300.00, 8300.00, 8000.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:00:31', '2025-05-08 20:00:31', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (3, 3, '王五', 2023, 1, 9000.00, 1200.00, 600.00, 10200.00, 9600.00, 0, NULL, NULL, '1月工资', '2025-05-08 20:00:31', '2025-05-08 20:00:31', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (4, 4, '赵六', 2023, 1, 8200.00, 900.00, 400.00, 8700.00, 8700.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (5, 5, '钱七', 2023, 1, 7800.00, 1000.00, 200.00, 8600.00, 8600.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (6, 6, '孙八', 2023, 1, 7600.00, 700.00, 300.00, 8000.00, 8000.00, 1, 'admin', '2025-05-08 20:18:54', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:18:54', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (7, 7, '周九', 2023, 1, 8800.00, 1100.00, 500.00, 9400.00, 9400.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (8, 8, '吴十', 2023, 1, 8100.00, 800.00, 400.00, 8500.00, 8500.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (9, 9, '郑十一', 2023, 1, 7950.00, 950.00, 350.00, 8550.00, 8550.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (10, 10, '王十二', 2023, 1, 8500.00, 1000.00, 400.00, 9100.00, 9100.00, 0, NULL, NULL, '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (11, 11, '冯十三', 2023, 1, 7300.00, 900.00, 300.00, 7900.00, 7900.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (12, 12, '陈十四', 2023, 1, 7650.00, 850.00, 250.00, 8250.00, 8250.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (13, 13, '褚十五', 2023, 1, 7900.00, 600.00, 200.00, 8300.00, 8300.00, 0, NULL, NULL, '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (14, 14, '卫十六', 2023, 1, 8700.00, 1200.00, 500.00, 9400.00, 9400.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (15, 15, '蒋十七', 2023, 1, 7400.00, 1000.00, 300.00, 8100.00, 8100.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (16, 16, '沈十八', 2023, 1, 8300.00, 950.00, 350.00, 8900.00, 8900.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (17, 17, '韩十九', 2023, 1, 7100.00, 700.00, 200.00, 7600.00, 7600.00, 0, NULL, NULL, '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (18, 18, '杨二十', 2023, 1, 8000.00, 1100.00, 600.00, 8500.00, 8500.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (19, 19, '朱二一', 2023, 1, 7750.00, 1050.00, 250.00, 8550.00, 8550.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (20, 20, '秦二二', 2023, 1, 7600.00, 900.00, 300.00, 8200.00, 8200.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (21, 21, '尤二三', 2023, 1, 8400.00, 1100.00, 450.00, 9050.00, 9050.00, 1, 'admin', '2025-05-08 21:43:21', '1月工资', '2025-05-08 20:17:50', '2025-05-08 21:43:21', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (22, 22, '许二四', 2023, 1, 7300.00, 950.00, 250.00, 8000.00, 8000.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (23, 23, '何二五', 2023, 1, 7500.00, 800.00, 200.00, 8100.00, 8100.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (24, 24, '吕二六', 2023, 1, 7950.00, 1000.00, 300.00, 8650.00, 8650.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (25, 25, '施二七', 2023, 1, 7850.00, 850.00, 250.00, 8450.00, 8450.00, 1, 'admin', '2025-05-08 21:42:52', '1月工资', '2025-05-08 20:17:50', '2025-05-08 21:42:52', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (26, 26, '张二八', 2023, 1, 8800.00, 1150.00, 600.00, 9350.00, 9350.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (27, 27, '王二九', 2023, 1, 8200.00, 1050.00, 400.00, 8850.00, 8850.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (28, 28, '李三十', 2023, 1, 7650.00, 900.00, 350.00, 8200.00, 8200.00, 1, 'admin', '2023-01-15 10:30:00', '1月工资', '2025-05-08 20:17:50', '2025-05-08 20:17:50', 'admin', 'admin');
INSERT INTO `sys_salary` VALUES (29, NULL, '李三十', 2000, 12, 213.00, 0.00, 0.00, 213.00, 213.00, NULL, '123', NULL, '123', '2025-05-08 21:13:48', '2025-05-08 21:13:48', 'admin', '1');
INSERT INTO `sys_salary` VALUES (30, NULL, '李三十', 2001, 12, 2000.00, 0.00, 0.00, 2000.00, 2000.00, NULL, '123', NULL, '21', '2025-05-08 21:49:45', '2025-05-08 21:49:45', 'admin', '1');
INSERT INTO `sys_salary` VALUES (31, NULL, '123', 2005, 12, 22222.00, 0.00, 0.00, 22222.00, 22222.00, NULL, '1', NULL, '1', '2025-05-08 21:57:48', '2025-05-08 21:57:48', 'admin', '1');
INSERT INTO `sys_salary` VALUES (32, NULL, '12', 2003, 12, 213.00, 0.00, 0.00, 213.00, 213.00, NULL, '1', NULL, '1', '2025-05-08 23:44:24', '2025-05-08 23:44:24', 'admin', '1');
INSERT INTO `sys_salary` VALUES (33, NULL, '12', 2003, 11, 123.00, 0.00, 0.00, 123.00, 123.00, NULL, '12', NULL, '12', '2025-05-08 23:45:49', '2025-05-08 23:45:49', 'admin', '1');
INSERT INTO `sys_salary` VALUES (34, NULL, '12', 2000, 12, 312.00, 0.00, 0.00, 312.00, 312.00, NULL, '123', NULL, '', '2025-05-09 00:03:42', '2025-05-09 00:03:42', 'admin', '1');
INSERT INTO `sys_salary` VALUES (35, NULL, '121', 2001, 2, 1233.00, 0.00, 0.00, 1233.00, 1233.00, NULL, '12', NULL, '', '2025-05-09 00:08:02', '2025-05-09 00:48:26', 'admin', '1');

-- ----------------------------
-- Table structure for sys_task
-- ----------------------------
DROP TABLE IF EXISTS `sys_task`;
CREATE TABLE `sys_task`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '任务内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `creator` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建者',
  `executor` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行人',
  `priority` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '优先级(高/中/低)',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态(未开始/进行中/已完成/已取消)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_title`(`title` ASC) USING BTREE,
  INDEX `idx_creator`(`creator` ASC) USING BTREE,
  INDEX `idx_executor`(`executor` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_task
-- ----------------------------
INSERT INTO `sys_task` VALUES (1, '开发登录功能', '实现用户登录认证功能，包括用户名密码验证', '2025-05-08 21:17:34', 'admin', 'developer1', '高', '进行中');
INSERT INTO `sys_task` VALUES (2, '设计数据库模型', '设计用户管理模块的数据库表结构', '2025-05-08 21:17:34', 'admin', 'developer2', '中', '已完成');
INSERT INTO `sys_task` VALUES (3, '编写项目文档', '编写系统使用说明文档', '2025-05-08 21:17:34', 'admin', 'developer3', '低', '未开始');
INSERT INTO `sys_task` VALUES (4, '修复BUG-001', '修复用户列表分页显示问题', '2025-05-08 21:17:34', 'admin', 'developer1', '高', '已完成');
INSERT INTO `sys_task` VALUES (5, '优化系统性能1', '对系统进行性能分1析和优化', '2025-05-08 21:17:34', 'admin1', 'developer2', '中', '进行中');
INSERT INTO `sys_task` VALUES (6, '修复BUG-00111', '123', '2025-05-08 21:29:52', '123', '1', '高', '已完成');
INSERT INTO `sys_task` VALUES (7, '开发注册功能', '实现用户注册流程，包括邮箱验证', '2025-05-08 21:42:33', 'admin', 'developer1', '中', '未开始');
INSERT INTO `sys_task` VALUES (8, '前端UI优化', '优化首页和用户中心的界面布局', '2025-05-08 21:42:33', 'admin', 'developer2', '低', '进行中');
INSERT INTO `sys_task` VALUES (9, '添加日志功能', '记录用户操作日志，便于追踪问题', '2025-05-08 21:42:33', 'admin', 'developer3', '高', '未开始');
INSERT INTO `sys_task` VALUES (10, '重构权限模块', '使用RBAC模型重构权限控制', '2025-05-08 21:42:33', 'admin', 'developer1', '高', '进行中');
INSERT INTO `sys_task` VALUES (11, '接口文档编写', '使用Swagger生成系统API文档', '2025-05-08 21:42:33', 'admin', 'developer2', '中', '已完成');
INSERT INTO `sys_task` VALUES (12, '测试登录模块', '对登录模块进行功能和安全性测试', '2025-05-08 21:42:33', 'admin', 'developer3', '中', '已完成');
INSERT INTO `sys_task` VALUES (13, '搭建CI/CD流程', '配置Jenkins实现自动构建部署', '2025-05-08 21:42:33', 'admin', 'developer1', '高', '进行中');
INSERT INTO `sys_task` VALUES (14, '开发通知系统', '支持邮件与站内消息发送', '2025-05-08 21:42:33', 'admin', 'developer2', '中', '未开始');
INSERT INTO `sys_task` VALUES (15, '整合第三方登录', '支持QQ、微信、GitHub登录', '2025-05-08 21:42:33', 'admin', 'developer3', '高', '未开始');
INSERT INTO `sys_task` VALUES (16, '优化数据库索引', '为查询频繁的字段添加索引', '2025-05-08 21:42:33', 'admin', 'developer1', '中', '进行中');
INSERT INTO `sys_task` VALUES (17, '编写单元测试', '为关键模块添加单元测试', '2025-05-08 21:42:33', 'admin', 'developer2', '高', '进行中');
INSERT INTO `sys_task` VALUES (18, '部署测试环境', '搭建独立测试环境供QA使用', '2025-05-08 21:42:33', 'admin', 'developer3', '低', '已完成');
INSERT INTO `sys_task` VALUES (19, '添加导出功能', '支持数据导出为Excel/CSV', '2025-05-08 21:42:33', 'admin', 'developer1', '中', '未开始');
INSERT INTO `sys_task` VALUES (20, '修复BUG-002', '修复权限控制失效问题', '2025-05-08 21:42:33', 'admin', 'developer2', '高', '已完成');
INSERT INTO `sys_task` VALUES (21, '添加缓存机制', '引入Redis缓存热门数据', '2025-05-08 21:42:33', 'admin', 'developer3', '中', '进行中');
INSERT INTO `sys_task` VALUES (22, '升级Spring版本', '将Spring Boot升级到最新版本', '2025-05-08 21:42:33', 'admin', 'developer1', '低', '未开始');
INSERT INTO `sys_task` VALUES (23, '支持多语言', '增加中英文切换功能', '2025-05-08 21:42:33', 'admin', 'developer2', '高', '未开始');
INSERT INTO `sys_task` VALUES (24, '编写安装脚本', '自动化部署脚本编写', '2025-05-08 21:42:33', 'admin', 'developer3', '中', '进行中');
INSERT INTO `sys_task` VALUES (25, '系统负载测试', '进行系统压力测试，分析瓶颈', '2025-05-08 21:42:33', 'admin', 'developer1', '高', '进行中');
INSERT INTO `sys_task` VALUES (26, '添加用户反馈', '用户可提交反馈与建议', '2025-05-08 21:42:33', 'admin', 'developer2', '低', '未开始');
INSERT INTO `sys_task` VALUES (27, '优化图片上传', '支持压缩与格式校验', '2025-05-08 21:42:33', 'admin', 'developer3', '中', '已完成');
INSERT INTO `sys_task` VALUES (28, '修复BUG-003', '修复移动端适配问题', '2025-05-08 21:42:33', 'admin', 'developer1', '中', '已完成');
INSERT INTO `sys_task` VALUES (29, '添加安全防护', '加入SQL注入和XSS防护机制', '2025-05-08 21:42:33', 'admin', 'developer2', '高', '进行中');
INSERT INTO `sys_task` VALUES (30, '完善日志系统', '分级别记录各类操作日志', '2025-05-08 21:42:33', 'admin', 'developer3', '中', '进行中');
INSERT INTO `sys_task` VALUES (31, '增加数据备份', '定期备份数据库并自动上传', '2025-05-08 21:42:33', 'admin', 'developer1', '高', '未开始');
INSERT INTO `sys_task` VALUES (32, '开发后台仪表盘', '展示系统运行状态和统计图表', '2025-05-08 21:42:33', 'admin', 'developer2', '中', '已完成');
INSERT INTO `sys_task` VALUES (33, '优化权限界面', '提升权限管理界面交互性', '2025-05-08 21:42:33', 'admin', 'developer3', '低', '未开始');
INSERT INTO `sys_task` VALUES (34, '开发标签功能', '支持文章添加自定义标签', '2025-05-08 21:42:33', 'admin', 'developer1', '中', '进行中');
INSERT INTO `sys_task` VALUES (35, '增加操作审计', '记录所有管理操作历史', '2025-05-08 21:42:33', 'admin', 'developer2', '高', '进行中');
INSERT INTO `sys_task` VALUES (36, '设计错误页', '自定义404和500错误页面', '2025-05-08 21:42:33', 'admin', 'developer3', '低', '已完成');
INSERT INTO `sys_task` VALUES (37, '开发搜索功能', '支持全文检索和筛选条件', '2025-05-08 21:42:33', 'admin', 'developer1', '高', '未开始');
INSERT INTO `sys_task` VALUES (38, '添加用户等级', '根据活跃度分级显示用户等级', '2025-05-08 21:42:33', 'admin', 'developer2', '中', '进行中');
INSERT INTO `sys_task` VALUES (39, '开发图表统计', '引入ECharts展示数据趋势', '2025-05-08 21:42:33', 'admin', 'developer3', '中', '已完成');
INSERT INTO `sys_task` VALUES (40, '修复BUG-004', '修复图表无法加载问题', '2025-05-08 21:42:33', 'admin', 'developer1', '中', '已完成');
INSERT INTO `sys_task` VALUES (41, '整合支付系统', '接入支付宝与微信支付', '2025-05-08 21:42:33', 'admin', 'developer2', '高', '未开始');
INSERT INTO `sys_task` VALUES (42, '优化系统启动', '缩短项目启动时间', '2025-05-08 21:42:33', 'admin', 'developer3', '中', '进行中');
INSERT INTO `sys_task` VALUES (43, '升级数据库版本', 'MySQL版本升级及兼容性调整', '2025-05-08 21:42:33', 'admin', 'developer1', '高', '未开始');
INSERT INTO `sys_task` VALUES (44, '开发权限组', '支持分组管理权限', '2025-05-08 21:42:33', 'admin', 'developer2', '中', '进行中');
INSERT INTO `sys_task` VALUES (45, '添加收藏功能', '用户可收藏喜欢的内容', '2025-05-08 21:42:33', 'admin', 'developer3', '低', '已完成');
INSERT INTO `sys_task` VALUES (46, '修复BUG-005', '修复无法导出报表的问题', '2025-05-08 21:42:33', 'admin', 'developer1', '高', '已完成');
INSERT INTO `sys_task` VALUES (47, '增加系统公告', '支持管理员发布系统公告', '2025-05-08 21:42:33', 'admin', 'developer2', '中', '进行中');
INSERT INTO `sys_task` VALUES (48, '优化接口性能', '减少接口响应时间', '2025-05-08 21:42:33', 'admin', 'developer3', '中', '进行中');
INSERT INTO `sys_task` VALUES (49, '重构项目结构', '模块拆分与依赖重构', '2025-05-08 21:42:33', 'admin', 'developer1', '高', '未开始');
INSERT INTO `sys_task` VALUES (50, '支持附件上传', '用户可上传文件并管理', '2025-05-08 21:42:33', 'admin', 'developer2', '中', '未开始');
INSERT INTO `sys_task` VALUES (51, '添加黑名单机制', '封禁违规用户账号', '2025-05-08 21:42:33', 'admin', 'developer3', '高', '进行中');
INSERT INTO `sys_task` VALUES (52, '设计新Logo', '设计符合品牌形象的新Logo', '2025-05-08 21:42:33', 'admin', 'developer1', '低', '未开始');
INSERT INTO `sys_task` VALUES (53, '添加评论功能', '用户可对内容进行评论', '2025-05-08 21:42:33', 'admin', 'developer2', '中', '已完成');
INSERT INTO `sys_task` VALUES (54, '开发通知中心', '集中展示所有通知信息', '2025-05-08 21:42:33', 'admin', 'developer3', '中', '进行中');
INSERT INTO `sys_task` VALUES (55, '完善帮助中心', '提供常见问题解答页面', '2025-05-08 21:42:33', 'admin', 'developer1', '低', '进行中');
INSERT INTO `sys_task` VALUES (56, '修复BUG-006', '修复通知无法读取的问题', '2025-05-08 21:42:33', 'admin', 'developer2', '高', '已完成');
INSERT INTO `sys_task` VALUES (57, '增加热搜功能', '展示当前热门关键词', '2025-05-08 21:42:33', 'admin', 'developer3', '中', '未开始');
INSERT INTO `sys_task` VALUES (58, '开发内容审核', '支持人工与机器审核内容', '2025-05-08 21:42:33', 'admin', 'developer1', '高', '进行中');
INSERT INTO `sys_task` VALUES (59, '优化网络请求', '统一接口调用封装', '2025-05-08 21:42:33', 'admin', 'developer2', '中', '进行中');
INSERT INTO `sys_task` VALUES (60, '支持批量操作', '支持批量删除、导出等功能', '2025-05-08 21:42:33', 'admin', 'developer3', '中', '已完成');
INSERT INTO `sys_task` VALUES (61, '增加管理员模块', '管理员可管理系统各模块', '2025-05-08 21:42:33', 'admin', 'developer1', '高', '未开始');
INSERT INTO `sys_task` VALUES (62, '开发积分系统', '用户行为可获得积分奖励', '2025-05-08 21:42:33', 'admin', 'developer2', '中', '进行中');
INSERT INTO `sys_task` VALUES (63, '优化注册流程', '简化流程并提高验证效率', '2025-05-08 21:42:33', 'admin', 'developer3', '中', '进行中');
INSERT INTO `sys_task` VALUES (64, '添加主题切换', '支持亮色与暗色主题', '2025-05-08 21:42:33', 'admin', 'developer1', '低', '已完成');
INSERT INTO `sys_task` VALUES (65, '修复BUG-007', '修复主题切换异常问题', '2025-05-08 21:42:33', 'admin', 'developer2', '中', '已完成');
INSERT INTO `sys_task` VALUES (66, '开发用户标签', '用户可自定义标签', '2025-05-08 21:42:33', 'admin', 'developer3', '低', '未开始');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电子邮箱',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态:0-正常,1-禁用',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 72 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'user1', '12345678', '用户1', '13912340001', 'user1@qq.com', 0, '2024-06-01 10:00:00', '2025-05-08 23:19:33', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (2, 'user2', '12345678', '用户2', '13912340002', 'user2@qq.com', 0, '2024-06-02 10:00:00', '2024-06-02 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (3, 'user3', '12345678', '用户3', '13912340003', 'user3@qq.com', 0, '2024-06-03 10:00:00', '2024-06-03 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (4, 'user4', '12345678', '用户4', '13912340004', 'user4@qq.com', 0, '2024-06-04 10:00:00', '2024-06-04 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (5, 'user5', '12345678', '用户5', '13912340005', 'user5@qq.com', 0, '2024-06-05 10:00:00', '2024-06-05 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (6, 'user6', '12345678', '用户6', '13912340006', 'user6@qq.com', 0, '2024-06-06 10:00:00', '2024-06-06 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (7, 'user7', '12345678', '用户7', '13912340007', 'user7@qq.com', 0, '2024-06-07 10:00:00', '2024-06-07 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (8, 'user8', '12345678', '用户8', '13912340008', 'user8@qq.com', 0, '2024-06-08 10:00:00', '2024-06-08 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (9, 'user9', '12345678', '用户9', '13912340009', 'user9@qq.com', 0, '2024-06-09 10:00:00', '2024-06-09 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (10, 'user10', '12345678', '用户10', '13912340010', 'user10@qq.com', 0, '2024-06-10 10:00:00', '2024-06-10 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (11, 'user11', '12345678', '用户11', '13912340011', 'user11@qq.com', 0, '2024-06-11 10:00:00', '2024-06-11 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (12, 'user12', '12345678', '用户12', '13912340012', 'user12@qq.com', 0, '2024-06-12 10:00:00', '2024-06-12 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (13, 'user13', '12345678', '用户13', '13912340013', 'user13@qq.com', 0, '2024-06-13 10:00:00', '2024-06-13 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (14, 'user14', '12345678', '用户14', '13912340014', 'user14@qq.com', 0, '2024-06-14 10:00:00', '2024-06-14 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (15, 'user15', '12345678', '用户15', '13912340015', 'user15@qq.com', 0, '2024-06-15 10:00:00', '2024-06-15 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (16, 'user16', '12345678', '用户16', '13912340016', 'user16@qq.com', 0, '2024-06-16 10:00:00', '2024-06-16 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (17, 'user17', '12345678', '用户17', '13912340017', 'user17@qq.com', 0, '2024-06-17 10:00:00', '2024-06-17 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (18, 'user18', '12345678', '用户18', '13912340018', 'user18@qq.com', 0, '2024-06-18 10:00:00', '2024-06-18 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (19, 'user19', '12345678', '用户19', '13912340019', 'user19@qq.com', 0, '2024-06-19 10:00:00', '2024-06-19 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (20, 'user20', '12345678', '用户20', '13912340020', 'user20@qq.com', 0, '2024-06-20 10:00:00', '2024-06-20 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (21, 'user21', '12345678', '用户21', '13912340021', 'user21@qq.com', 0, '2024-06-21 10:00:00', '2024-06-21 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (22, 'user22', '12345678', '用户22', '13912340022', 'user22@qq.com', 0, '2024-06-22 10:00:00', '2024-06-22 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (23, 'user23', '12345678', '用户23', '13912340023', 'user23@qq.com', 0, '2024-06-23 10:00:00', '2024-06-23 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (24, 'user24', '12345678', '用户24', '13912340024', 'user24@qq.com', 0, '2024-06-24 10:00:00', '2024-06-24 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (25, 'user25', '12345678', '用户25', '13912340025', 'user25@qq.com', 0, '2024-06-25 10:00:00', '2024-06-25 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (26, 'user26', '12345678', '用户26', '13912340026', 'user26@qq.com', 0, '2024-06-26 10:00:00', '2024-06-26 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (27, 'user27', '12345678', '用户27', '13912340027', 'user27@qq.com', 0, '2024-06-27 10:00:00', '2024-06-27 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (28, 'user28', '12345678', '用户28', '13912340028', 'user28@qq.com', 0, '2024-06-28 10:00:00', '2024-06-28 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (29, 'user29', '12345678', '用户29', '13912340029', 'user29@qq.com', 0, '2024-06-29 10:00:00', '2024-06-29 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (30, 'user30', '12345678', '用户30', '13912340030', 'user30@qq.com', 0, '2024-06-30 10:00:00', '2024-06-30 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (31, 'user31', '12345678', '用户31', '13912340031', 'user31@qq.com', 0, '2024-07-01 10:00:00', '2024-07-01 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (32, 'user32', '12345678', '用户32', '13912340032', 'user32@qq.com', 0, '2024-07-02 10:00:00', '2024-07-02 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (33, 'user33', '12345678', '用户33', '13912340033', 'user33@qq.com', 0, '2024-07-03 10:00:00', '2024-07-03 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (34, 'user34', '12345678', '用户34', '13912340034', 'user34@qq.com', 0, '2024-07-04 10:00:00', '2024-07-04 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (35, 'user35', '12345678', '用户35', '13912340035', 'user35@qq.com', 0, '2024-07-05 10:00:00', '2024-07-05 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (36, 'user36', '12345678', '用户36', '13912340036', 'user36@qq.com', 0, '2024-07-06 10:00:00', '2024-07-06 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (37, 'user37', '12345678', '用户37', '13912340037', 'user37@qq.com', 0, '2024-07-07 10:00:00', '2024-07-07 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (38, 'user38', '12345678', '用户38', '13912340038', 'user38@qq.com', 0, '2024-07-08 10:00:00', '2024-07-08 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (39, 'user39', '12345678', '用户39', '13912340039', 'user39@qq.com', 0, '2024-07-09 10:00:00', '2024-07-09 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (40, 'user40', '12345678', '用户40', '13912340040', 'user40@qq.com', 0, '2024-07-10 10:00:00', '2024-07-10 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (41, 'user41', '12345678', '用户41', '13912340041', 'user41@qq.com', 0, '2024-07-11 10:00:00', '2024-07-11 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (42, 'user42', '12345678', '用户42', '13912340042', 'user42@qq.com', 0, '2024-07-12 10:00:00', '2024-07-12 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (43, 'user43', '12345678', '用户43', '13912340043', 'user43@qq.com', 0, '2024-07-13 10:00:00', '2024-07-13 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (44, 'user44', '12345678', '用户44', '13912340044', 'user44@qq.com', 0, '2024-07-14 10:00:00', '2024-07-14 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (45, 'user45', '12345678', '用户45', '13912340045', 'user45@qq.com', 0, '2024-07-15 10:00:00', '2024-07-15 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (46, 'user46', '12345678', '用户46', '13912340046', 'user46@qq.com', 0, '2024-07-16 10:00:00', '2024-07-16 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (47, 'user47', '12345678', '用户47', '13912340047', 'user47@qq.com', 0, '2024-07-17 10:00:00', '2024-07-17 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (48, 'user48', '12345678', '用户48', '13912340048', 'user48@qq.com', 0, '2024-07-18 10:00:00', '2024-07-18 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (49, 'user49', '12345678', '用户49', '13912340049', 'user49@qq.com', 0, '2024-07-19 10:00:00', '2024-07-19 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (50, 'user50', '12345678', '用户50', '13912340050', 'user50@qq.com', 0, '2024-07-20 10:00:00', '2024-07-20 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (51, 'user51', '12345678', '用户51', '13912340051', 'user51@qq.com', 0, '2024-07-21 10:00:00', '2024-07-21 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (52, 'user52', '12345678', '用户52', '13912340052', 'user52@qq.com', 0, '2024-07-22 10:00:00', '2024-07-22 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (53, 'user53', '12345678', '用户53', '13912340053', 'user53@qq.com', 0, '2024-07-23 10:00:00', '2024-07-23 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (54, 'user541', '12345678', '用户54', '13912340054', 'user54@qq.com', 0, '2024-07-24 10:00:00', '2025-05-08 14:40:29', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (55, 'user55', '12345678', '用户55', '13912340055', 'user55@qq.com', 0, '2024-07-25 10:00:00', '2024-07-25 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (56, 'user56', '12345678', '用户56', '13912340056', 'user56@qq.com', 0, '2024-07-26 10:00:00', '2024-07-26 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (57, 'user57', '12345678', '用户57', '13912340057', 'user57@qq.com', 0, '2024-07-27 10:00:00', '2024-07-27 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (58, 'user58', '12345678', '用户58', '13912340058', 'user58@qq.com', 0, '2024-07-28 10:00:00', '2024-07-28 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (59, 'user59', '12345678', '用户59', '13912340059', 'user59@qq.com', 0, '2024-07-29 10:00:00', '2024-07-29 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (60, 'user60', '12345678', '用户60', '13912340060', 'user60@qq.com', 0, '2024-07-30 10:00:00', '2024-07-30 10:00:00', 'admin', 'admin');
INSERT INTO `sys_user` VALUES (61, 'admin', '123', '123', '13333366532', '123@qwe.com', 0, '2025-05-07 20:03:03', '2025-05-07 20:57:08', 'admin', NULL);
INSERT INTO `sys_user` VALUES (62, 'admin1', '123123123', '123', '13333366532', '123@qwe.com', 0, '2025-05-07 20:57:33', '2025-05-07 21:03:06', 'admin', NULL);
INSERT INTO `sys_user` VALUES (63, 'admin112', '12321312', '123', '13333366531', '123@qwe.com', 0, '2025-05-07 20:58:41', '2025-05-07 21:02:50', 'admin', NULL);
INSERT INTO `sys_user` VALUES (64, '12', '12', '21', '13333366531', '12@1.com', 0, '2025-05-08 14:39:52', '2025-05-08 14:39:52', 'admin', NULL);
INSERT INTO `sys_user` VALUES (65, '123', '12343333', '123', '13333366531', '11@1.com', 0, '2025-05-08 15:28:29', '2025-05-08 20:47:52', 'admin', NULL);
INSERT INTO `sys_user` VALUES (67, '12312', '12345678', '12', NULL, NULL, 0, '2025-05-09 00:45:39', '2025-05-09 00:45:39', NULL, NULL);
INSERT INTO `sys_user` VALUES (68, '1233', '123456', '12', NULL, NULL, 0, '2025-05-09 00:50:31', '2025-05-09 00:50:31', NULL, NULL);
INSERT INTO `sys_user` VALUES (69, '123123', '123123', '123', NULL, NULL, 0, '2025-05-09 00:51:23', '2025-05-09 00:51:23', NULL, NULL);
INSERT INTO `sys_user` VALUES (70, '12312123', '12312312', '123', NULL, NULL, 0, '2025-05-09 00:58:03', '2025-05-09 00:58:03', NULL, NULL);
INSERT INTO `sys_user` VALUES (71, '1231231', '123123', '12', '', '', 0, '2025-05-09 01:14:54', '2025-05-09 01:42:23', NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
