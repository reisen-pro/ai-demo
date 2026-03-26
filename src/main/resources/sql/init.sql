-- 启用 pgvector 扩展 (如果镜像未自动启用)
CREATE EXTENSION IF NOT EXISTS vector;

-- ==========================================
-- 1. 业务表：聊天会话 (Chat Sessions)
-- 用于管理用户的对话窗口
-- ==========================================
CREATE TABLE IF NOT EXISTS chat_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id VARCHAR(255) NOT NULL,          -- 用户标识 (可以是匿名ID或用户名)
    title VARCHAR(255),                     -- 会话标题 (可由AI生成)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                             metadata JSONB                          -- 扩展字段 (如：使用的模型名称、温度设置等)
                             );

-- 为查询用户会话添加索引
CREATE INDEX idx_chat_sessions_user_id ON chat_sessions(user_id);
CREATE INDEX idx_chat_sessions_updated_at ON chat_sessions(updated_at DESC);

-- ==========================================
-- 2. 业务表：聊天消息 (Chat Messages)
-- 存储具体的对话内容
-- ==========================================
CREATE TABLE IF NOT EXISTS chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES chat_sessions(id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL,              -- 角色: 'USER', 'ASSISTANT', 'SYSTEM'
    content TEXT NOT NULL,                  -- 消息文本内容
    token_count INTEGER,                    -- 消耗的 Token 数 (可选)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                                                              metadata JSONB                          -- 扩展字段 (如：引用的文档ID列表、延迟时间等)
                                                              );

-- 为查询会话消息添加索引
CREATE INDEX idx_chat_messages_session_id ON chat_messages(session_id);
CREATE INDEX idx_chat_messages_created_at ON chat_messages(created_at ASC);

-- ==========================================
-- 3. 业务表：知识库源文件 (Knowledge Documents)
-- 记录上传的原始文件，用于追踪向量数据的来源
-- ==========================================
CREATE TABLE IF NOT EXISTS knowledge_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    filename VARCHAR(255) NOT NULL,
    file_type VARCHAR(50),                  -- PDF, TXT, MD 等
    file_size_bytes BIGINT,
    status VARCHAR(50) DEFAULT 'PROCESSING',-- PROCESSING, READY, FAILED
    chunk_count INTEGER DEFAULT 0,          -- 被切分成了多少个向量块
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                             metadata JSONB                          -- 扩展字段 (如：上传者、标签)
                             );

-- ==========================================
-- 4. Spring AI 自动管理的向量表 (参考结构)
-- 【重要】通常不需要手动执行此建表语句，
-- Spring AI 会在应用启动时根据 application.yml 配置自动创建。
-- 这里仅作为结构参考，以便你理解元数据如何存储。
-- ==========================================
/*
CREATE TABLE IF NOT EXISTS vector_store (
    id UUID PRIMARY KEY,
    embedding vector(768),       -- 维度取决于你的 embedding 模型 (nomic-embed-text 是 768维)
    content TEXT,                -- 文本切片内容
    metadata JSONB               -- 【关键】这里存储 document_id (关联 knowledge_documents)、page_number 等
);

-- 创建向量索引 (HNSW 算法，适合高性能检索)
-- 注意：维度 768 需与实际模型匹配
CREATE INDEX IF NOT EXISTS vector_store_embedding_idx
ON vector_store USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);
*/