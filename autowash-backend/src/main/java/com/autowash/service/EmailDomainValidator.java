package com.autowash.service;

public interface EmailDomainValidator {
    boolean canReceiveEmail(String email);
}
