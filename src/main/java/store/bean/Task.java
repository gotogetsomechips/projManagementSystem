package store.bean;

import java.util.Date;

public class Task {
    private Integer id;
    private String title;
    private String content;
    private Date createTime;
    private Integer creatorId;
    private String creatorName;
    private Integer executorId;
    private String executorName;
    private Integer priority;
    private Integer status;
    private Date startTime;
    private Date endTime;
    private Date updateTime;
    
    // Getters and Setters
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }
    public Date getCreateTime() {
        return createTime;
    }
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
    public Integer getCreatorId() {
        return creatorId;
    }
    public void setCreatorId(Integer creatorId) {
        this.creatorId = creatorId;
    }
    public String getCreatorName() {
        return creatorName;
    }
    public void setCreatorName(String creatorName) {
        this.creatorName = creatorName;
    }
    public Integer getExecutorId() {
        return executorId;
    }
    public void setExecutorId(Integer executorId) {
        this.executorId = executorId;
    }
    public String getExecutorName() {
        return executorName;
    }
    public void setExecutorName(String executorName) {
        this.executorName = executorName;
    }
    public Integer getPriority() {
        return priority;
    }
    public void setPriority(Integer priority) {
        this.priority = priority;
    }
    public Integer getStatus() {
        return status;
    }
    public void setStatus(Integer status) {
        this.status = status;
    }
    public Date getStartTime() {
        return startTime;
    }
    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }
    public Date getEndTime() {
        return endTime;
    }
    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }
    public Date getUpdateTime() {
        return updateTime;
    }
    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}