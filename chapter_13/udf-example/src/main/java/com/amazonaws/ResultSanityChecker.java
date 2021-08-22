/*-
 * #%L
 * udf-example
 * %%
 * Copyright (C) 2019 - 2021 Amazon Web Services
 * %%
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * #L%
 */
package com.amazonaws;

public class ResultSanityChecker {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Expected exactly 1 argument which is the payload to be decrypted.");
            System.exit(0);
        }

        String encryptedPayload = args[0];

        UdfExample handler = new UdfExample();
        String decryptedPayload = handler.decrypt(encryptedPayload);

        System.out.println("Encrypted payload: " + encryptedPayload);
        System.out.println("Decrypted payload: " + decryptedPayload);
    }
}
