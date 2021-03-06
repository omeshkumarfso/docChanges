--Table
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlobDataLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SolutionDocId] [int] NOT NULL,
	[IsFileUploaded] [bit] NOT NULL,
	[IsFileUpdated] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BlobDataLog] ADD  DEFAULT ((0)) FOR [IsFileUploaded]
GO



--Trigger
Create trigger [dbo].[BlobDataLogTrigger]
On [dbo].[tbl_SolutionDocument_Process] 
After INSERT
As
Begin 
Insert into BlobDataLog
SELECT I.SolutionDocID, 0,0 FROM INSERTED I
End


--SP
-- =============================================
-- Author:		OP Bijarniya
-- Create date: 17 Dec 2021
-- Description:	Make sync from tbl_SoltionDocument_Process to BlobDataLog
-- =============================================
CREATE PROCEDURE sp_SyncTblSolutionDocumentProcessBlobDataLog
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Insert into BlobDataLog 
	Select SolutionDocID, 0, 0 from tbl_SolutionDocument_Process 
	where SolutionDocID not in (Select SolutionDocID from BlobDataLog)
	
END
GO
