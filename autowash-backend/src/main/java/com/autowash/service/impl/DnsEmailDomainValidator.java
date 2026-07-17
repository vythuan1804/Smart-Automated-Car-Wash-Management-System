package com.autowash.service.impl;

import com.autowash.service.EmailDomainValidator;
import java.net.IDN;
import java.util.Hashtable;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.InitialDirContext;
import org.springframework.stereotype.Service;

@Service
public class DnsEmailDomainValidator implements EmailDomainValidator {

    @Override
    public boolean canReceiveEmail(String email) {
        String domain = extractDomain(email);
        if (domain == null) {
            return false;
        }

        try {
            String asciiDomain = IDN.toASCII(domain);
            return hasDnsRecord(asciiDomain, "MX") || hasDnsRecord(asciiDomain, "A") || hasDnsRecord(asciiDomain, "AAAA");
        } catch (IllegalArgumentException exception) {
            return false;
        }
    }

    private String extractDomain(String email) {
        if (email == null) {
            return null;
        }

        String normalizedEmail = email.trim();
        int atIndex = normalizedEmail.lastIndexOf('@');
        if (atIndex <= 0 || atIndex == normalizedEmail.length() - 1) {
            return null;
        }

        String domain = normalizedEmail.substring(atIndex + 1).trim().toLowerCase();
        if (domain.isBlank() || domain.endsWith(".") || domain.contains("..")) {
            return null;
        }

        return domain;
    }

    private boolean hasDnsRecord(String domain, String recordType) {
        Hashtable<String, String> environment = new Hashtable<>();
        environment.put("java.naming.factory.initial", "com.sun.jndi.dns.DnsContextFactory");
        environment.put("com.sun.jndi.dns.timeout.initial", "2000");
        environment.put("com.sun.jndi.dns.timeout.retries", "1");

        try {
            Attributes attributes = new InitialDirContext(environment).getAttributes(domain, new String[]{recordType});
            Attribute records = attributes.get(recordType);
            return records != null && records.size() > 0;
        } catch (NamingException exception) {
            return false;
        }
    }
}
