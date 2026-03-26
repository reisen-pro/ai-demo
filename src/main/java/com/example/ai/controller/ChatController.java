package com.example.ai.controller;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;

@RestController
@RequestMapping("/api/chat")
public class ChatController {

    private final ChatClient chatClient;
    private final ChatModel chatModel;

    // 注入自动配置的 ChatClient (推荐方式)
    public ChatController(ChatClient.Builder builder, ChatModel chatModel) {
        this.chatClient = builder.build();
        this.chatModel = chatModel;
    }

    /**
     * 简单对话接口
     * GET /api/chat/simple?message=你好
     */
    @GetMapping("/simple")
    public String simpleChat(@RequestParam(defaultValue = "你好，介绍一下你自己") String message) {
        return chatClient.prompt()
                .user(message)
                .call()
                .content();
    }

    /**
     * 流式对话接口 (Server-Sent Events)








     Collections

     Environments

     Specs

     Flows

     * 前端需支持 SSE 接收
     */
    @GetMapping(value = "/stream", produces = "text/event-stream")
    public Flux<String> streamChat(@RequestParam String message) {
        return chatClient.prompt()
                .user(message)
                .stream()
                .content();
    }
}
