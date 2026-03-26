package com.example.ai.entity;

import jakarta.persistence.*;
import org.springframework.data.annotation.Id;

import java.util.UUID;

@Entity
@Table(name = "chat_messages")
public class ChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id")
    private ChatSession session;

    private String role; // USER, ASSISTANT
    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(columnDefinition = "jsonb")
    private String metadata; // 存储引用的文档ID列表
}
