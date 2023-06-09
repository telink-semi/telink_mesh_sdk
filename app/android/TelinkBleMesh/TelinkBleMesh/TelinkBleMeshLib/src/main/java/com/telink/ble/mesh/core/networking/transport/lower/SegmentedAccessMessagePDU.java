/********************************************************************************************************
 * @file SegmentedAccessMessagePDU.java
 *
 * @brief for TLSR chips
 *
 * @author telink
 * @date     Sep. 30, 2017
 *
 * @par     Copyright (c) 2017, Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
 *
 *          Licensed under the Apache License, Version 2.0 (the "License");
 *          you may not use this file except in compliance with the License.
 *          You may obtain a copy of the License at
 *
 *              http://www.apache.org/licenses/LICENSE-2.0
 *
 *          Unless required by applicable law or agreed to in writing, software
 *          distributed under the License is distributed on an "AS IS" BASIS,
 *          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *          See the License for the specific language governing permissions and
 *          limitations under the License.
 *******************************************************************************************************/
package com.telink.ble.mesh.core.networking.transport.lower;

import com.telink.ble.mesh.core.networking.NetworkLayerPDU;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;

/**
 * Created by kee on 2019/8/9.
 */

public class SegmentedAccessMessagePDU extends LowerTransportPDU {


    /**
     * 1 = Segmented MeshCommand
     */
    private final byte seg = 1;

    /**
     * Application Key Flag
     */
    private byte akf;

    /**
     * Application key identifier
     */
    private byte aid;

    /**
     * Size of TransMIC
     */
    private int szmic;

    /**
     * Least significant bits of SeqAuth
     */
    private int seqZero;

    /**
     * Segment Offset number
     */
    private int segO;

    /**
     * Last Segment number
     */
    private int segN;

    /**
     * Segment m of the Upper Transport Access PDU
     */
    private byte[] segmentM;


    @Override
    public int getType() {
        return TYPE_SEGMENTED_ACCESS_MESSAGE;
    }

    @Override
    public boolean segmented() {
        return true;
    }

    @Override
    public byte[] toByteArray() {
        int headerLength = 4;
        final int akfAid = ((akf << 6) | aid);
        int payloadLength = segmentM.length;
        ByteBuffer resultBuffer = ByteBuffer.allocate(headerLength + payloadLength).order(ByteOrder.BIG_ENDIAN);
        resultBuffer.put((byte) ((seg << 7) | akfAid));
        resultBuffer.put((byte) ((szmic << 7) | ((seqZero >> 6) & 0x7F)));
        resultBuffer.put((byte) (((seqZero << 2) & 0xFC) | ((segO >> 3) & 0x03)));
        resultBuffer.put((byte) (((segO << 5) & 0xE0) | ((segN) & 0x1F)));
        resultBuffer.put(segmentM);
        return resultBuffer.array();
    }

    public boolean parse(NetworkLayerPDU networkLayerPDU) {
        byte[] lowerTransportPdu = networkLayerPDU.getTransportPDU();
        this.akf = (byte) ((lowerTransportPdu[0] >> 6) & 0x01);
        this.aid = (byte) (lowerTransportPdu[0] & 0x3F);
        this.szmic = (lowerTransportPdu[1] >> 7) & 0x01;
        this.seqZero = ((lowerTransportPdu[1] & 0x7F) << 6) | ((lowerTransportPdu[2] & 0xFC) >> 2);
        this.segO = ((lowerTransportPdu[2] & 0x03) << 3) | ((lowerTransportPdu[3] & 0xE0) >> 5);
        this.segN = ((lowerTransportPdu[3]) & 0x1F);

        this.segmentM = new byte[lowerTransportPdu.length - 4];
        System.arraycopy(lowerTransportPdu, 4, this.segmentM, 0, this.segmentM.length);
        return this.segmentM != null && this.segmentM.length >= 1;
    }


    public byte getSeg() {
        return seg;
    }

    public byte getAkf() {
        return akf;
    }

    public void setAkf(byte akf) {
        this.akf = akf;
    }

    public byte getAid() {
        return aid;
    }

    public void setAid(byte aid) {
        this.aid = aid;
    }

    public int getSzmic() {
        return szmic;
    }

    public void setSzmic(int szmic) {
        this.szmic = szmic;
    }

    public int getSeqZero() {
        return seqZero;
    }

    public void setSeqZero(int seqZero) {
        this.seqZero = seqZero;
    }

    public int getSegO() {
        return segO;
    }

    public void setSegO(int segO) {
        this.segO = segO;
    }

    public int getSegN() {
        return segN;
    }

    public void setSegN(int segN) {
        this.segN = segN;
    }

    public byte[] getSegmentM() {
        return segmentM;
    }

    public void setSegmentM(byte[] segmentM) {
        this.segmentM = segmentM;
    }
}
