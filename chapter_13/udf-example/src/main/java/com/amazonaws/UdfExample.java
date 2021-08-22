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

import com.amazonaws.athena.connector.lambda.handlers.UserDefinedFunctionHandler;
import com.google.common.annotations.VisibleForTesting;
import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

public class UdfExample extends UserDefinedFunctionHandler {
    private static final Logger LOGGER = LoggerFactory.getLogger(UdfExample.class);
    private static final String SOURCE_TYPE = "Packt_UdfExample";

    public UdfExample() {
        super(SOURCE_TYPE);
    }

    public String decrypt(String encryptedField) {
        try {
            String encryptionKey = getEncryptionKey();
            return symmetricDecrypt(encryptedField, encryptionKey);
        }
        catch (Exception ex) {
            LOGGER.warn("decrypt: failed to decrypt {}.", encryptedField, ex);
            /*
             * NOTE: See that we are returning null here instead of throwing an exception,
             *       this is worth taking into consideration when implementing your own
             *       UDF because an exception will cause your entire query to fail, which
             *       may or may not be what you want to have happen.
             */
            return null;
        }
    }

    /**
     * This is an extremely POOR usage of AES and is only mean to illustrate how one could
     * use a UDF for masking a field using encryption. In production scenarios we would recommend
     * using AWS KMS for Key Management and a strong cipher like AES-GCM.
     *
     * @param text The text to decrypt.
     * @param secretKey The password/key to use to decrypt the text.
     * @return The decrypted text.
     */
    @VisibleForTesting
    protected String symmetricDecrypt(String text, String secretKey)
            throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, BadPaddingException,
            IllegalBlockSizeException
    {
        Cipher cipher;
        String encryptedString;
        byte[] encryptText;
        byte[] raw;
        SecretKeySpec skeySpec;
        raw = Base64.decodeBase64(secretKey);
        skeySpec = new SecretKeySpec(raw, "AES");
        encryptText = Base64.decodeBase64(text);
        cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, skeySpec);
        encryptedString = new String(cipher.doFinal(encryptText));
        return encryptedString;
    }

    /**
     * DO _NOT_ manage keys like this in real world usage. We are hard coding a key here to work
     * with the tutorial's generated data set. In production scenarios we would recommend
     * using AWS KMS for Key Management and a strong cipher like AES-GCM.
     *
     * @return A String representation of the AES encryption key to use to decrypt data.
     */
    @VisibleForTesting
    protected String getEncryptionKey()
    {
        //must be exactly 24 chars or the KeySpec will fail. In general this is a poor, but simple, way to store the key.
        return "AMzDLG4D039Km2IxIzQwfg==";
    }
}
