# Spring AI + Ollama + PostgreSQL (pgvector) 本地大模型实战项目

本项目是一个基于 **JDK 21** 和 **Spring Boot 4.0.4** 构建的本地大语言模型应用脚手架。它利用 **Spring AI** 统一抽象层，集成 **Ollama** 作为本地推理引擎，并使用 **PostgreSQL (pgvector)** 作为向量数据库，实现了零成本、数据隐私安全的 AI 应用开发范式。

## 🚀 技术栈

- **语言**: Java 21
- **框架**: Spring Boot 4.0.4, Spring AI 2.0.0-M2
- **构建工具**: Maven
- **LLM 运行时**: Ollama (支持本地模型)
- **向量数据库**: PostgreSQL + pgvector 扩展
- **开发工具**: IntelliJ IDEA

## 📂 项目结构

src/main/java/com/example/ai    
├── SpringAiOllamaApplication.java # 启动入口   
├── controller  
│ └── ChatController.java # 提供 RESTful 聊天接口     
└── service # 业务逻辑层     
src/main/resources     
└── application.yml # 核心配置文件


## 🛠️ 核心功能

1. **本地大模型对话**: 通过 Spring AI 的 `ChatClient` 无缝调用本地 Ollama 模型，无需 API Key，无网络延迟。
2. **RAG 就绪 (Retrieval-Augmented Generation)**: 集成了 `spring-ai-starter-vector-store-pgvector`，支持将文档向量化存入 PostgreSQL，实现基于私有知识库的问答。
3. **流式响应**: 支持 SSE (Server-Sent Events) 流式输出，提升用户体验。
4. **自动 Schema 管理**: 配置 `initialize-schema: true` 后，应用启动时自动在数据库中创建向量表和索引。

## ⚙️ 快速开始

### 前置要求
1. 安装配置jdk21
2. 安装配置PostgreSQL，安装扩展pgvector
3. 安装 **Ollama** 并拉取模型：
   ```bash
   ollama pull #model-name
   ollama pull nomic-embed-text #如果需要本地向量化，需拉取此模型：ollama pull nomic-embed-text