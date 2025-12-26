package com.example.demo;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DatabaseInitializer {

    @Bean
    public CommandLineRunner initializeDatabase(StudentRepository studentRepository) {
        return args -> {
            // Create sample student data
            studentRepository.save(new Student("Aarav Patel", "aarav.patel@example.com", "Computer Science"));
            studentRepository.save(new Student("Bhavna Singh", "bhavna.singh@example.com", "Information Technology"));
            studentRepository.save(new Student("Chetan Kumar", "chetan.kumar@example.com", "Data Science"));
            studentRepository.save(new Student("Deepika Sharma", "deepika.sharma@example.com", "Artificial Intelligence"));
            studentRepository.save(new Student("Esha Gupta", "esha.gupta@example.com", "Web Development"));
            studentRepository.save(new Student("Faizan Ahmed", "faizan.ahmed@example.com", "Cloud Computing"));
            studentRepository.save(new Student("Gita Verma", "gita.verma@example.com", "Mobile Development"));
            studentRepository.save(new Student("Harsh Rajput", "harsh.rajput@example.com", "Cybersecurity"));
            
            System.out.println("Database initialized with sample student data!");
        };
    }
}
