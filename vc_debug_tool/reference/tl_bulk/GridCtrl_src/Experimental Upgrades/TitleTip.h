/********************************************************************************************************
 * @file	TitleTip.h
 *
 * @brief	This is the header file for BLE SDK
 *
 * @author	Mesh Group
 * @date	2021
 *
 * @par     Copyright (c) 2017, Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
 *          All rights reserved.
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
 *
 *******************************************************************************************************/
#if !defined(AFX_TITLETIP_H__C7165DA1_187F_11D1_992F_895E185F9C72__INCLUDED_)
#define AFX_TITLETIP_H__C7165DA1_187F_11D1_992F_895E185F9C72__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// TitleTip.h : header file
//

#define TITLETIP_CLASSNAME _T("ZTitleTip")

/////////////////////////////////////////////////////////////////////////////
// CTitleTip window

class CTitleTip : public CWnd
{
// Construction
public:
	CTitleTip();
	virtual ~CTitleTip();
	virtual BOOL Create( CWnd *pParentWnd);

// Attributes
public:

// Operations
public:
	void Show(CRect rectTitle, LPCTSTR lpszTitleText, 
              int xoffset = 0, int nMaxChars = -1, 
              LPRECT lpHoverRect = NULL, LPLOGFONT lpLogFont = NULL,
              DWORD dwFormat = DT_LEFT|DT_NOCLIP|DT_EDITCONTROL|DT_NOPREFIX|DT_WORDBREAK);
    void Hide();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CTitleTip)
	public:
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	//}}AFX_VIRTUAL

// Implementation
public:

protected:
	CWnd *m_pParentWnd;
	CRect m_rectTitle;
    CRect m_rectHover;
    CRect m_rectDisplay;
    CString m_strTitle;		// for use in OnPaint()
    DWORD m_dwFormat;

	// Generated message map functions
protected:
	//{{AFX_MSG(CTitleTip)
	afx_msg void OnMouseMove(UINT nFlags, CPoint point);
	afx_msg void OnPaint();
	afx_msg void OnSysKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_TITLETIP_H__C7165DA1_187F_11D1_992F_895E185F9C72__INCLUDED_)
