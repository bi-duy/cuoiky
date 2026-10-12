-- ==============================================================================
-- BỔ SUNG ĐẦY ĐỦ 100 CÂU HỎI ETS TOEIC READING 09 VÀO CSDL [de tanh]
-- BẢO ĐẢM KẾT NỐI TRỰC TIẾP TRONG SQL SERVER TRÊN MÁY (LAPTOP-MAALSNS1)
-- ==============================================================================
USE [de tanh];
GO

DECLARE @DeId INT = (SELECT TOP 1 DeThiId FROM dbo.DeThi WHERE MaDe = 'Reading v09');
IF @DeId IS NULL
BEGIN
    INSERT INTO dbo.DeThi (MaDe, TenDe, ThoiGianPhut, TongSoCau, TrangThai, NguoiTao)
    VALUES ('Reading v09', N'ETS TOEIC READING TEST 09', 75, 100, N'Hoạt động', 'GV001');
    SET @DeId = SCOPE_IDENTITY();
END
ELSE
BEGIN
    UPDATE dbo.DeThi SET TongSoCau = 100, ThoiGianPhut = 75 WHERE DeThiId = @DeId;
END

DECLARE @Part6Id INT = (SELECT PhanThiId FROM dbo.PhanThi WHERE DeThiId = @DeId AND PartNumber = 6);
DECLARE @Part7Id INT = (SELECT PhanThiId FROM dbo.PhanThi WHERE DeThiId = @DeId AND PartNumber = 7);

DECLARE @dvId INT;
DECLARE @qId INT;

-- ==============================================================================
-- PART 6 BỔ SUNG: CÂU 135 -> 146
-- ==============================================================================

-- 1. Đoạn văn 135 - 138: E-mail về Workshop digital storytelling
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part6Id AND SoThuTuCau = 135)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part6Id, N'Questions 135-138 refer to the following e-mail.',
    N'To: Sam Heinz
From: Northways Professional Development
Sent: April 20
Subject: Workshop 4/28–4/30

Dear Workshop Participants,

We look forward to seeing you at the digital storytelling workshop. On the first day, when you enter the Albin College campus, attendants will ------- you to lot 43 and the Toteman Building. We will begin each day in conference room 9. Coffee, tea, snacks, and fruit ------- in the mornings. Lunch will be sandwiches and salads from Black Horse Restaurant. -------.

In the afternoons, we will be working in the computer lab. We suggest that you assemble some images that you would like to use for your project. It will be ------- for you to have them saved on a digital storage device beforehand. If you have any questions, please e-mail us.

Very Best,
Gina Kapuski', N'E-mail', NULL, 2);
    SET @dvId = SCOPE_IDENTITY();

    -- 135
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part6Id, @dvId, 135, N'135. On the first day, attendants will ------- you to lot 43...', 'B', N'Động từ "direct" mang nghĩa hướng dẫn/chỉ đường cho ai đó đến địa điểm.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'offer'), (@qId, 'B', N'direct'), (@qId, 'C', N'pass'), (@qId, 'D', N'instruct');

    -- 136
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part6Id, @dvId, 136, N'136. Coffee, tea, snacks, and fruit ------- in the mornings.', 'A', N'Cần thì tương lai bị động "will be provided" cho đồ ăn nhẹ và đồ uống.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'will be provided'), (@qId, 'B', N'were provided'), (@qId, 'C', N'providers'), (@qId, 'D', N'are providing');

    -- 137
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part6Id, @dvId, 137, N'137. Lunch will be sandwiches and salads from Black Horse Restaurant. -------.', 'C', N'Câu liên kết hợp lý về bữa ăn: "Please let us know if you have any dietary restrictions."');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'Some prior experience working with digital files is assumed.'),
    (@qId, 'B', N'Please do not bring any copyrighted material to the workshop.'),
    (@qId, 'C', N'Please let us know if you have any dietary restrictions.'),
    (@qId, 'D', N'There is a one-time parking charge of fifteen dollars.');

    -- 138
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part6Id, @dvId, 138, N'138. It will be ------- for you to have them saved on a digital storage device beforehand.', 'A', N'Tính từ "useful" (hữu ích) phù hợp nhất với ngữ cảnh chuẩn bị tài liệu trước.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'useful'), (@qId, 'B', N'surprised'), (@qId, 'C', N'difficult'), (@qId, 'D', N'amazing');
END

-- 2. Đoạn văn 139 - 142: Article "Venley Foods Responsive to Changing Consumers"
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part6Id AND SoThuTuCau = 139)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part6Id, N'Questions 139-142 refer to the following article.',
    N'Venley Foods Responsive to Changing Consumers

Who cares where the tomatoes in your salad actually came from? -------, an increasing number of people do, according to a study conducted by the Consumer Group. In fact, the study shows that many consumers would pay an average of 10 percent more when given the exact source of a fresh food product. -------. Some grocery stores, such as Venley Foods in Boston, have taken advantage of the trend and used it to implement ------- branding and marketing. "If we can tell a story about our product," says Venley Foods CEO Minji Kim, "then we''ve added ------- in the minds of consumers."', N'Article', NULL, 3);
    SET @dvId = SCOPE_IDENTITY();

    -- 139
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part6Id, @dvId, 139, N'139. Who cares where the tomatoes in your salad actually came from? -------, an increasing number of people do...', 'B', N'Trạng từ "Apparently" (Rõ ràng là / Có vẻ như) đứng đầu câu để trả lời cho câu hỏi tu từ trước đó.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'Carefully'), (@qId, 'B', N'Apparently'), (@qId, 'C', N'Formerly'), (@qId, 'D', N'Rarely');

    -- 140
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part6Id, @dvId, 140, N'140. In fact, the study shows that many consumers would pay an average of 10 percent more... -------.', 'D', N'Câu bổ trợ số liệu tiếp nối câu trước: "The number increases to 20 percent in large cities."');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'Fresh food can be refrigerated for up to two days.'),
    (@qId, 'B', N'Many grocery stores have been extending their hours.'),
    (@qId, 'C', N'Most studies are published in consumer magazines.'),
    (@qId, 'D', N'The number increases to 20 percent in large cities.');

    -- 141
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part6Id, @dvId, 141, N'141. ...used it to implement ------- branding and marketing.', 'C', N'Cần tính từ so sánh hơn "smarter" bổ nghĩa cho danh từ "branding and marketing".');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'smarts'), (@qId, 'B', N'smartly'), (@qId, 'C', N'smarter'), (@qId, 'D', N'smartness');

    -- 142
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part6Id, @dvId, 142, N'142. ...then we''ve added ------- in the minds of consumers.', 'A', N'Cụm từ "added value" mang nghĩa gia tăng giá trị trong tâm trí người tiêu dùng.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'value'), (@qId, 'B', N'time'), (@qId, 'C', N'obstacles'), (@qId, 'D', N'bonus');
END

-- 3. Đoạn văn 143 - 146: Article "Nylobe, Inc., Announces Newest Development Project"
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part6Id AND SoThuTuCau = 143)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part6Id, N'Questions 143-146 refer to the following article.',
    N'Nylobe, Inc., Announces Newest Development Project

SEATTLE (May 1)—Researchers at technology firm Nylobe, Inc., are working to develop a sensor capable of detecting corrosion caused by environmental exposure. Corrosion is a major contributor to ------- losses in the aircraft industry each year. "This will be a major ------- for commercial airline fleets," says Mel Laveau, Nylobe''s CEO. "The sensor will decrease both labor and maintenance costs without being too expensive."

According to Ms. Laveau, the sensor will work by detecting corrosion in its early stages, when the problem can be corrected simply by removing the corroded material. -------. In the structure of large aircraft, some critical joints can be particularly susceptible to corrosion. -------, the sensor can be used to inspect these areas and then target the most likely areas of concern.', N'Article', NULL, 4);
    SET @dvId = SCOPE_IDENTITY();

    -- 143
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part6Id, @dvId, 143, N'143. Corrosion is a major contributor to ------- losses in the aircraft industry each year.', 'C', N'Cần tính từ "financial" bổ nghĩa cho danh từ "losses" (những thiệt hại tài chính).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'financially'), (@qId, 'B', N'financed'), (@qId, 'C', N'financial'), (@qId, 'D', N'finances');

    -- 144
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part6Id, @dvId, 144, N'144. "This will be a major ------- for commercial airline fleets," says Mel Laveau...', 'D', N'Danh từ "asset" mang nghĩa tài sản quý giá / lợi thế lớn đối với các đội tàu bay.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'balance'), (@qId, 'B', N'examination'), (@qId, 'C', N'expectation'), (@qId, 'D', N'asset');

    -- 145
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part6Id, @dvId, 145, N'145. ...when the problem can be corrected simply by removing the corroded material. -------.', 'A', N'Câu giải thích tiếp theo việc phát hiện ăn mòn sớm: "This will reduce the need for making expensive structural repairs."');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'This will reduce the need for making expensive structural repairs.'),
    (@qId, 'B', N'The parts have all been replaced with higher quality materials.'),
    (@qId, 'C', N'The next stage of the project involves scanning the affected areas.'),
    (@qId, 'D', N'Its style and sleek design made it popular with the public.');

    -- 146
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part6Id, @dvId, 146, N'146. ...some critical joints can be particularly susceptible to corrosion. -------, the sensor can be used...', 'B', N'Liên từ "Similarly" liên kết việc cảm biến cũng được áp dụng tương tự.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'Meanwhile'), (@qId, 'B', N'Similarly'), (@qId, 'C', N'Otherwise'), (@qId, 'D', N'Fortunately');
END

-- ==============================================================================
-- PART 7 BỔ SUNG: CÂU 152 -> 200
-- ==============================================================================

-- Đoạn 152 - 153: Tin nhắn trao đổi
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 152)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 152-153 refer to the following text-message chain.',
    N'Jason Salter (1:45 P.M.)
Liz, the meeting is starting in fifteen minutes. Where are you?

Liz Ortiz (1:47 P.M.)
The train has been stopped on the tracks for a while. There seems to be some kind of problem. I still hope to make the meeting.

Jason Salter (1:50 P.M.)
Okay. I''ll save you a seat.

Liz Ortiz (1:59 P.M.)
There''s just been an announcement. There''s a disabled train up ahead. It''ll be awhile.

Jason Salter (2:00 P.M.)
Don''t worry. If there are any questions for our department, I''ll handle them.

Liz Ortiz (2:01 P.M.)
Thanks. I''ll call you later.', N'Text Message', NULL, 3);
    SET @dvId = SCOPE_IDENTITY();

    -- 152
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 152, N'What is suggested about Mr. Salter?', 'D', N'Jason viết "If there are any questions for our department, I''ll handle them" => cùng làm việc ở 1 bộ phận.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'He is leading the meeting.'),
    (@qId, 'B', N'He commutes to work by train.'),
    (@qId, 'C', N'He has many questions for Ms. Ortiz.'),
    (@qId, 'D', N'He works in the same department as Ms. Ortiz.');

    -- 153
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 153, N'At 1:59 P.M., what does Ms. Ortiz imply when she writes, "It''ll be awhile"?', 'C', N'Tàu bị hỏng ở phía trước và "It''ll be awhile" nghĩa là sẽ mất nhiều thời gian, cô ấy có khả năng sẽ lỡ cuộc họp.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'The meeting is running late.'),
    (@qId, 'B', N'She is still preparing her notes.'),
    (@qId, 'C', N'She will likely miss the meeting.'),
    (@qId, 'D', N'She has not boarded the train yet.');
END

-- Đoạn 154 - 155: E-mail Sardha''s Banquet Hall
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 154)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 154-155 refer to the following e-mail.',
    N'From: tbogosian@sardhasconvention.com
To: pradalaily@dmcv.com
Date: 22 March
Subject: Your reservation
Attachment: Prada party

Dear Ms. Prada,
Thank you for choosing Sardha''s Banquet Hall to host your event on 30 August. Unfortunately, West Hall will be under renovation in August, and we will be unable to accommodate your group in that room. However, your party will fit comfortably in East Hall. This room features floor-to-ceiling windows and a full view of the river. The 15 percent deposit we have received will hold the reservation.

As indicated when you completed your request through our Web site, your total price of $1,600 includes a full-course meal that includes appetizers, soup or salad, main course, and dessert. Attached to this e-mail please find a copy of the menu presented to guests with options for appetizer and main course.

Tomas Bogosian
General Manager', N'E-mail', NULL, 4);
    SET @dvId = SCOPE_IDENTITY();

    -- 154
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 154, N'What is one purpose of the e-mail?', 'C', N'Email thông báo chuyển phòng từ West Hall sang East Hall do sửa chữa.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'To cancel a reservation'),
    (@qId, 'B', N'To apologize for an error'),
    (@qId, 'C', N'To indicate a room change'),
    (@qId, 'D', N'To request an extra deposit');

    -- 155
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 155, N'What is suggested about Ms. Prada?', 'D', N'Đoạn văn ghi: "As indicated when you completed your request through our Web site" => Đặt phòng qua trang web.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'She has paid her bill in full.'),
    (@qId, 'B', N'She eats at Sardha''s regularly.'),
    (@qId, 'C', N'She works in the food industry.'),
    (@qId, 'D', N'She made the reservation online.');
END

-- Đoạn 156 - 157: Memo Cập nhật hệ điều hành
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 156)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 156-157 refer to the following memo.',
    N'MEMO
To: All Employees
From: IT Supervisor
Subject: OS Update
Date: 27 May

All company computers in the Melbourne and Victoria offices require an update to the operating system. This update will prepare our computers for the new version of our accounting software, which should arrive in the first week of July. Technicians will install the new operating system beginning on 3 June. We expect the process to be completed around 16 June, providing time to work out any bugs with the operating system before the accounting software is uploaded.

Completing the entire process will require you to log in so that we can verify the system is working as anticipated. Therefore, if you plan to go on holiday during this period, please inform IT Support immediately of the dates you will be out so that we can plan an alternate date to accommodate your schedule.

If you have any questions, please contact IT Support staff at extension 48.', N'Memo', NULL, 5);
    SET @dvId = SCOPE_IDENTITY();

    -- 156
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 156, N'When is the installation of the operating system expected to be finished?', 'B', N'Văn bản ghi: "We expect the process to be completed around 16 June" => Vào giữa tháng 6.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'In the first week of June'),
    (@qId, 'B', N'In the middle of June'),
    (@qId, 'C', N'At the end of June'),
    (@qId, 'D', N'In the first week of July');

    -- 157
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 157, N'Who is asked to contact IT Support?', 'D', N'Đoạn văn ghi: "if you plan to go on holiday during this period, please inform IT Support immediately" => Nhân viên nghỉ phép.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'Employees who do not need the accounting software'),
    (@qId, 'B', N'Accountants already using the new operating system'),
    (@qId, 'C', N'Staff who work outside the offices'),
    (@qId, 'D', N'Employees who are taking time off');
END

-- Đoạn 158 - 160: Letter Clarke-Ellis Construction
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 158)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 158-160 refer to the following letter.',
    N'Clarke-Ellis Construction
#20 Murphy Industrial Park, St. Michael BB23028
1-246-555-0126
Full-service commercial contractor serving all of Barbados

4 June
Ida Gutierrez - Darling Cove Inn, Mango Drive, Folkestone BB24017

Dear Ms. Gutierrez,
Thank you for contacting Clarke-Ellis Construction for your roofing project. — [1] —. After inspecting the property, I have confirmed that the inn''s main roof is in good condition and requires no repairs at this time. However, the roof of the inn''s porch appears to be at least twenty years old and is worn beyond repair. — [2] —. Clarke-Ellis Construction can remove and dispose of the existing porch roof and install a new one. The replacement will be comparable to the quality, style, and colour of the inn''s main roof. We will use only commercial-grade leak barriers, insulation, and shingles manufactured by West Indies Weatherproofing, Inc. The estimated total cost, inclusive of labour and materials, is $3,260. — [3] —. Additional fees would apply should you want us to make other improvements, such as painting the porch or replacing porch screens.

Please call me at the number above to discuss scheduling or any questions you have about the work. — [4] —. I hope to hear from you soon.

Sincerely,
Grayson Clarke, Co-owner, Clarke-Ellis Construction', N'Letter', NULL, 6);
    SET @dvId = SCOPE_IDENTITY();

    -- 158
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 158, N'Why did Mr. Clarke write the letter?', 'A', N'Bức thư đề xuất phương án sửa chữa mái hiên cùng chi phí ước tính $3,260 => Đề xuất công việc (work proposal).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'To provide a work proposal'),
    (@qId, 'B', N'To ask for a project extension'),
    (@qId, 'C', N'To request an inspection report'),
    (@qId, 'D', N'To submit a revised cost estimate');

    -- 159
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 159, N'What is indicated about West Indies Weatherproofing, Inc.?', 'C', N'Thư nêu: "shingles manufactured by West Indies Weatherproofing, Inc." => Công ty sản xuất vật liệu lợp mái.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'It is installing a new porch at Darling Cove Inn.'),
    (@qId, 'B', N'It provides painting services.'),
    (@qId, 'C', N'It produces roofing materials.'),
    (@qId, 'D', N'It is owned by Clarke-Ellis Construction.');

    -- 160
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 160, N'In which of the positions marked [1], [2], [3], and [4] does the following sentence best belong? "It must be replaced."', 'B', N'Câu "It must be replaced." nối liền sau câu miêu tả mái hiên đã xuống cấp không thể sửa (worn beyond repair) tại vị trí [2].');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'[1]'),
    (@qId, 'B', N'[2]'),
    (@qId, 'C', N'[3]'),
    (@qId, 'D', N'[4]');
END

-- Đoạn 161 - 164: Quảng cáo tuyển dụng Goldhorse Press
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 161)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 161-164 refer to the following advertisement.',
    N'Position: Assistant Editor
Date Posted: March 15

Description:
Goldhorse Press, an independent book publishing company focusing on North American gardening, has provided gardening advice for home gardeners for over 50 years. We are currently seeking an assistant editor to join our expanding team in Charlotte, North Carolina. We offer an excellent benefits package that includes medical and dental insurance.

Responsibilities:
Assist editors in the acquisition of titles with mainstream appeal; develop manuscripts, collaborate with outside support, and work closely with two managing editors.

Requirements/Qualifications:
• Bachelor''s degree in a related field
• Minimum of one year of experience in the publishing industry
• Ability to pay close attention to detail
• Comfortable working as a team member
• Some experience in gardening preferred
• Immediate availability

E-mail résumé and salary requirements to humanresources@goldhorsepress.com.', N'Advertisement', NULL, 7);
    SET @dvId = SCOPE_IDENTITY();

    -- 161
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 161, N'What title would most likely be published by Goldhorse Press?', 'C', N'Công ty chuyên về sách làm vườn (gardening) => Tựa đề phù hợp nhất là "Planting Perennial Flowers".');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'Growing Your Baking Business'),
    (@qId, 'B', N'A Tour Guide to North Carolina'),
    (@qId, 'C', N'Planting Perennial Flowers'),
    (@qId, 'D', N'The Efficient Executive');

    -- 162
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 162, N'What is indicated about Goldhorse Press?', 'B', N'Mô tả ghi: "benefits package that includes medical and dental insurance" => Cung cấp bảo hiểm cho nhân viên.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'It is hiring two assistant editors.'),
    (@qId, 'B', N'It provides insurance to employees.'),
    (@qId, 'C', N'It publishes trade journals.'),
    (@qId, 'D', N'It is a newly established company.');

    -- 163
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 163, N'What is a requirement for the advertised position?', 'B', N'Yêu cầu ghi: "Ability to pay close attention to detail" tương đương "An aptitude for noticing details".');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'A passion for gardening'),
    (@qId, 'B', N'An aptitude for noticing details'),
    (@qId, 'C', N'A master''s degree in a related field'),
    (@qId, 'D', N'An ability to work without supervision');

    -- 164
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 164, N'What are applicants asked to do?', 'D', N'Dòng cuối: "E-mail résumé and salary requirements" => Gửi mức lương mong muốn (Indicate desired pay).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'Submit a job application form'),
    (@qId, 'B', N'Submit a list of references'),
    (@qId, 'C', N'Indicate availability'),
    (@qId, 'D', N'Indicate desired pay');
END

-- Đoạn 165 - 168: Nhóm chat sáp nhập Derek Boutique
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 165)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 165-168 refer to the following online chat session.',
    N'Derek Marshall [8:19 A.M.]
Hi, everyone. I wanted to give an update on our merger with Ridgewood, Inc., and see if you have had any meetings.

Mai Chung [8:20 A.M.]
Have we worked out which of our Derek Boutique locations will stay open?

Derek Marshall [8:21 A.M.]
Yes, Derek Boutique will keep 35 stores open with the full line of clothing. The other 12 will move their inventory to the Ridgewood, Inc., locations.

Nikita Tamboli [8:22 A.M.]
When should the moves be scheduled? This month?

Derek Marshall [8:23 A.M.]
No, the 12 locations don''t need to be vacated until the end of next month. Could you schedule this for five weeks from now?

Anthony Rossi [8:24 A.M.]
I met over lunch with my managers earlier this week, including the two that I just hired.

Nikita Tamboli [8:25 A.M.]
That would work.

Mai Chung [8:27 A.M.]
I''ll be meeting with the managers on my staff, too, to review the transition plan.

Derek Marshall [8:28 A.M.]
This is good work, everyone.

Anthony Rossi [8:29 A.M.]
When will the whole process be complete?

Derek Marshall [8:30 A.M.]
Within about 6 months.', N'Online Chat', NULL, 8);
    SET @dvId = SCOPE_IDENTITY();

    -- 165
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 165, N'Where do the writers most likely work?', 'B', N'Derek Boutique hoạt động trong lĩnh vực thời trang: "full line of clothing" => Công ty quần áo (clothing company).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'At a marketing firm'),
    (@qId, 'B', N'At a clothing company'),
    (@qId, 'C', N'At a real estate agency'),
    (@qId, 'D', N'At a newspaper publisher');

    -- 166
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 166, N'How many stores will be closing?', 'C', N'Đoạn hội thoại: "keep 35 stores open... The other 12 will move their inventory" => 12 cửa hàng đóng cửa.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'5'),
    (@qId, 'B', N'6'),
    (@qId, 'C', N'12'),
    (@qId, 'D', N'35');

    -- 167
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 167, N'At 8:25 A.M., what does Ms. Tamboli most likely mean when she writes, "That would work"?', 'D', N'Nikita trả lời về đề xuất lên lịch di dời trong 5 tuần tới: có thể sắp xếp lịch trình trong khung thời gian đó.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'The current inventory will be doubled.'),
    (@qId, 'B', N'Ridgewood, Inc., will close in two weeks.'),
    (@qId, 'C', N'Mr. Marshall will meet with the managers.'),
    (@qId, 'D', N'She can schedule the moves in the proposed time frame.');

    -- 168
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 168, N'What is suggested about Ms. Chung and Mr. Rossi?', 'A', N'Mai Chung nói: "managers on my staff", Rossi nói: "my managers" => Cả hai đều quản lý nhân viên dưới quyền.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'They supervise other employees.'),
    (@qId, 'B', N'They often shop at Ridgewood, Inc.'),
    (@qId, 'C', N'They recently went to lunch together.'),
    (@qId, 'D', N'They have concerns about the merger.');
END

-- Đoạn 169 - 171: Bài báo Dr. Esther Nujoma
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 169)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 169-171 refer to the following article.',
    N'From the Shadows to the Limelight
By Calum Ellwood

Dr. Esther Nujoma, an agricultural biotechnologist with the Namibia Institute of Applied Sciences, is the author of several books on the practical applications of biotechnology. — [1] —. According to book critic Paige Kinnock of the London Daily Register, "Dr. Nujoma has increased the public''s awareness of the role of biotechnology in daily life through her ability to translate highly complex scientific material into simple language."

Her latest work, Shining Behind Shadows, marks a departure from her usual subject matter. — [2] —. Rather, the book highlights the lives and careers of twelve of her peers from Africa and Asia. The idea came to her three years ago at a conference in Chile. As Dr. Nujoma recalls, "Listening to one speaker after another, I realized that many of my colleagues are from regions of the world, such as Africa and Asia, that were underrepresented." — [3] —.

The book is quite compelling. Dr. Nujoma brings to life the stories of how her peers were drawn to the profession and the effort they pour into their work.

The book does, however, fall short in one respect: it provides insights only into the lives and careers of those working in the field of agricultural biotechnology. I would have welcomed the stories of those specializing in animal, marine, or medical biotechnology, too. — [4] —. Even so, Dr. Nujoma has again succeeded in creating a work that speaks to experts and laypeople alike.', N'Article', NULL, 9);
    SET @dvId = SCOPE_IDENTITY();

    -- 169
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 169, N'What is NOT indicated about Dr. Nujoma?', 'D', N'Paige Kinnock chỉ là nhà phê bình sách đánh giá về cô ấy, không có chi tiết cô ấy được phỏng vấn bởi London Daily Register.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'She has visited Chile.'),
    (@qId, 'B', N'She is a talented writer.'),
    (@qId, 'C', N'She is based out of Namibia.'),
    (@qId, 'D', N'She was interviewed by the London Daily Register.');

    -- 170
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 170, N'What does Mr. Ellwood say about Shining Behind Shadows?', 'A', N'Sách tập trung vào cuộc đời sự nghiệp của 12 đồng nghiệp từ châu Phi và châu Á (scientists from Africa and Asia).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'It focuses on scientists from Africa and Asia.'),
    (@qId, 'B', N'It was released three years ago.'),
    (@qId, 'C', N'It details why Dr. Nujoma chose her career.'),
    (@qId, 'D', N'It describes various branches of biotechnology.');

    -- 171
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 171, N'In which of the positions marked [1], [2], [3], and [4] does the following sentence best belong? "Its focus is not on applying biotechnology in real-life situations."', 'B', N'Câu "marks a departure from her usual subject matter" được tiếp nối rất logic bởi câu giải thích ở vị trí [2].');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'[1]'),
    (@qId, 'B', N'[2]'),
    (@qId, 'C', N'[3]'),
    (@qId, 'D', N'[4]');
END

-- Đoạn 172 - 175: Thông báo Phà chở khách
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 172)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 172-175 refer to the following notice.',
    N'KINGSTON-GARNET ISLAND PASSENGER FERRY SERVICE
General Information

Beginning on 15 May, the Kingston-Garnet Island Passenger Ferry Service will resume service for eight weeks during the summer season. Ferries run daily every half hour from 7 a.m. to 8 p.m. The last ferry to Garnet Island will depart at 7:30 p.m. The last ferry from Garnet Island will leave at 8 p.m.

Bicycles are permitted on the passenger ferries. Bicyclists should arrive 30 minutes prior to departure and wait in the special bicycle lane to be loaded first. There are five racks that hold 50 bicycles on every passenger ferry.

No motorized vehicles are permitted on Garnet Island. Overnight parking is allowed in the main ferry terminal lot in Kingston. Rates are $5 per hour for up to 4 hours and a flat fee of $25 for four to 24 hours.

Visit our Web site at www.kgferryservice.com for photographs of the ferry boats, a map of Garnet Island, lists of local attractions on the island, and information about peak-hour fare increases and group discounts.', N'Notice', NULL, 10);
    SET @dvId = SCOPE_IDENTITY();

    -- 172
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 172, N'What is indicated about the ferry service?', 'A', N'Thông báo nêu: "for eight weeks during the summer season" => Chỉ phục vụ theo mùa (available only seasonally).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'It is available only seasonally.'),
    (@qId, 'B', N'Its boats were recently upgraded.'),
    (@qId, 'C', N'It takes an hour to reach the island.'),
    (@qId, 'D', N'It runs more frequently on weekends.');

    -- 173
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 173, N'What is true about bicyclists on the ferries?', 'D', N'Thông báo ghi: "Bicyclists should arrive 30 minutes prior to departure" => Nên đến bến phà sớm.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'They are last to board the boat.'),
    (@qId, 'B', N'They must purchase a special ticket.'),
    (@qId, 'C', N'They cannot travel on the 7:30 P.M. trip.'),
    (@qId, 'D', N'They should arrive at the terminal early.');

    -- 174
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 174, N'What is not allowed on Garnet Island?', 'B', N'Thông báo cấm xe có động cơ: "No motorized vehicles are permitted on Garnet Island" => Không được lái ô tô.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'Renting bicycles'),
    (@qId, 'B', N'Driving cars'),
    (@qId, 'C', N'Camping overnight'),
    (@qId, 'D', N'Taking photographs');

    -- 175
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 175, N'What is indicated about the ferry tickets?', 'C', N'Web có thông tin "peak-hour fare increases" => Giá vé thay đổi tùy theo giờ đi.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'They can be purchased at stores in Kingston.'),
    (@qId, 'B', N'They are less expensive for children.'),
    (@qId, 'C', N'They vary in price depending on the time of travel.'),
    (@qId, 'D', N'They are more expensive if purchased on the boat.');
END

-- Đoạn 176 - 180: Biên nhận & E-mail Green Stripe Press
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 176)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 176-180 refer to the following receipt and e-mail.',
    N'RECEIPT - Green Stripe Press
Order Number: GSP20896
Customer Information: Shoebox Mountain (Jason Ho <jasonho@shoeboxmountain.com>)
Order Date: December 14 (PREPAID: online order)
Expected Delivery: December 18–20

Quantity | Item # | Item | Price
1 | CAL201 | Complimentary Wild Animals Calendar | $ 0.00
7 | ARB132 | Accounting Record Book ($19.99 each) | $139.93

Subtotal: $139.93
Discount: $ 0.00
Tax @ 6%: $ 8.40
Shipping & Handling: $ 0.00
Total: $148.33

There is no charge for shipping and handling for corporate accounts. For questions regarding this order, please contact customerservice@greenstripepress.com.

---

To: customerservice@greenstripepress.com
From: Jason Ho <jasonho@shoeboxmountain.com>
Date: December 18
Subject: Order #GSP20896

Dear Green Stripe Press,
I am writing regarding my most recent order (#GSP20896), which was delivered today. If you check my original order, you will see that I ordered six accounting record books. You sent us seven copies. I''d like to return the one I didn''t order and have our corporate credit card refunded, together with the shipping cost the return will incur. Let me know how you would like me to proceed.

On a different note, congratulations on the calendar you included in my order! The photos are even more stunning than those in the Ancient Castles calendar you sent us last year. Some staff members saw mine and want copies of their own. Would you mind sending two more our way?

Best,
Jason Ho, Owner
Shoebox Mountain', N'Multiple Documents', NULL, 11);
    SET @dvId = SCOPE_IDENTITY();

    -- 176
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 176, N'Why was Mr. Ho not charged a shipping fee?', 'B', N'Biên nhận ghi chú: "There is no charge for shipping and handling for corporate accounts" => Mua cho doanh nghiệp.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'He took advantage of a promotion.'),
    (@qId, 'B', N'He made the purchase for his company.'),
    (@qId, 'C', N'He picked up his order in person.'),
    (@qId, 'D', N'He overpaid for shipping on a previous order.');

    -- 177
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 177, N'What is true about Mr. Ho''s order?', 'D', N'Dự kiến giao ngày 18–20 tháng 12 và Jason viết ngày 18 tháng 12 "delivered today" => Giao hàng đúng hạn.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'It was damaged in transit.'),
    (@qId, 'B', N'It included fragile items.'),
    (@qId, 'C', N'It was paid for by check.'),
    (@qId, 'D', N'It was delivered on time.');

    -- 178
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 178, N'According to the e-mail, what was Mr. Ho sent by mistake?', 'D', N'Jason chỉ đặt 6 quyển nhưng được giao 7 quyển => Thừa 1 quyển sổ kế toán (An extra accounting book).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'A castle book he did not order'),
    (@qId, 'B', N'A calendar for last year'),
    (@qId, 'C', N'An incorrect refund check'),
    (@qId, 'D', N'An extra accounting book');

    -- 179
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 179, N'What is one reason Mr. Ho wrote the e-mail?', 'A', N'Jason khen bộ lịch ảnh động vật đẹp "congratulations on the calendar... photos are even more stunning" => Khen ngợi món quà tặng.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'To offer praise for an item'),
    (@qId, 'B', N'To complain about a price'),
    (@qId, 'C', N'To order some photo albums'),
    (@qId, 'D', N'To recommend a graphic designer');

    -- 180
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 180, N'In the e-mail, the phrase "our way" in paragraph 2, line 4, is closest in meaning to', 'B', N'"sending two more our way" có nghĩa là gửi thêm 2 cuốn tới địa chỉ của chúng tôi (to our address).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'in our style'),
    (@qId, 'B', N'to our address'),
    (@qId, 'C', N'at our expense'),
    (@qId, 'D', N'for our benefit');
END

-- Đoạn 181 - 185: Biểu mẫu liên hệ & E-mail Hilgrave Historical Commission
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 181)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 181-185 refer to the following contact form and e-mail.',
    N'Contact the Hilgrave Historical Commission
Name: Roger Witmondt (roger@witmondtlocations.com)
Comment:
I work as a movie location scout. At this time, I need to find a location for a client''s short film. The film will be set in the early 1930s, and I understand that Hilgrave has some interesting architecture from that era.

Could you suggest places I should visit when I am in Hilgrave next month? Specifically, I am looking for a vacant building with an old-fashioned storefront that has distinctive details like stripe-patterned awnings and framed display windows. While having easy access to electricity would be ideal, it is not critical; my client has a generator that can be used if necessary. My client''s aesthetic requirements are the most important consideration. Thank you for your assistance.

---

To: roger@witmondtlocations.com
From: brandi_schaertl@hilgravehistoricalcommission.org
Date: 28 September
Subject: The information you requested
Attachment: Hilgrave Sites

Dear Mr. Witmondt,
Thank you for reaching out to the Hilgrave Historical Commission. The attached brochure lists the main areas of historical interest in Hilgrave. Some buildings may not meet all your requirements, but they might be worth considering.

One building that is not on the attached list is the old record store at 188 Main Street. It has been closed to business for the past ten years or so, but it seems to meet your criteria. The owner, Luke Nylund, is currently using it for storage; I would be happy to put you in touch with him. I doubt you will have trouble getting permission from him to use the space. While Hilgrave was once a bustling town, these days there are fewer businesses in operation. Many of the town''s residents would appreciate the attention a short film might bring to the area.

Best regards,
Brandi Schaertl', N'Multiple Documents', NULL, 12);
    SET @dvId = SCOPE_IDENTITY();

    -- 181
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 181, N'Why is Mr. Witmondt looking for a filming location in Hilgrave?', 'D', N'Roger cần tìm kiến trúc đầu thập niên 1930 cho phim ngắn => Kiến trúc đại diện cho 1 thời kỳ lịch sử cụ thể.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'It is known for its scenic mountain views.'),
    (@qId, 'B', N'It is a short distance from his office.'),
    (@qId, 'C', N'Its business district has appeared in other films.'),
    (@qId, 'D', N'Its buildings represent a particular time period.');

    -- 182
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 182, N'On the contact form, the word "critical" in paragraph 2, line 4, is closest in meaning to', 'B', N'"it is not critical" mang nghĩa không quá thiết yếu/bắt buộc (essential).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'judgmental'),
    (@qId, 'B', N'essential'),
    (@qId, 'C', N'sustainable'),
    (@qId, 'D', N'available');

    -- 183
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 183, N'What is implied about 188 Main Street?', 'D', N'Brandi viết căn nhà này đáp ứng đúng các tiêu chí của Roger (mái che hoa văn sọc, khung kính trưng bày cổ kính) => Có các chi tiết thiết kế trang trí độc đáo.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'It was once used as a residence.'),
    (@qId, 'B', N'It is frequently visited by tourists.'),
    (@qId, 'C', N'It has several floors.'),
    (@qId, 'D', N'It has decorative design features.');

    -- 184
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 184, N'What does Ms. Schaertl offer to do?', 'C', N'Brandi viết: "I would be happy to put you in touch with him" => Kết nối với chủ nhà Luke Nylund.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'Advertise a forthcoming film'),
    (@qId, 'B', N'Arrange to have a building cleaned'),
    (@qId, 'C', N'Connect Mr. Witmondt with a building''s owner'),
    (@qId, 'D', N'Help Mr. Witmondt acquire necessary permits from the town');

    -- 185
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 185, N'What does Ms. Schaertl suggest that Hilgrave needs?', 'A', N'Cô ấy viết người dân thị trấn sẽ đánh giá cao sự chú ý mà bộ phim mang lại => Cần quảng bá / chú ý nhiều hơn (More publicity).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'More publicity'),
    (@qId, 'B', N'Additional parking'),
    (@qId, 'C', N'A storage facility'),
    (@qId, 'D', N'A business directory');
END

-- Đoạn 186 - 190: 2 E-mail và Trang Web Anson House
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 186)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 186-190 refer to the following e-mails and Web page.',
    N'Email 1:
To: Cornelia Payne <cpayne@roughwing.co.uk>
From: Pragya Mehta <pmehta@airsky.in>
Subject: Lecture | Date: 18 January | Attachment: Notes

Dear Cornelia,
I am sorry for the late notice, but I will not be able to join you for the lecture. My new position at the university in Mumbai requires me to remain on campus. Although I know you are fully prepared to deliver the lecture on your own, I have attached a copy of the notes I had prepared for the presentation. After you review them, let me know if there is anything else I can add. I had very much looked forward to traveling to Freeport, The Bahamas, for the first time and to seeing you again. I certainly miss working with you at the City University. Good luck with the lecture.
Pragya

---

Email 2:
To: Ezra Halton <ehalton@ansonhouse.org>
From: Cornelia Payne <cpayne@roughwing.co.uk>
Subject: Information | Date: 20 January

Dear Mr. Halton,
I am pleased to confirm that 19 March works well for the lecture at the Anson House. As I had mentioned to you over the phone, I will be giving the lecture on my own. My publisher, Alphagamma Press, will be sending 30 copies of my most recent work, coauthored with Dr. Pragya Mehta, to your institution. You and I will both receive an e-mail confirmation from Alphagamma when the books ship. They should arrive at least a week before the lecture. I look forward to meeting you soon.
Cornelia Payne

---

Web Page:
The Anson House - Freeport, The Bahamas (Speaker Series)
Tickets for lectures are $35 each or may be purchased at a reduced rate of $90 for the series of three. Complimentary refreshments will be served. Reservations are not required but are recommended.

• 7 March, 7:00–8:30 P.M.: Ms. Janelle Pears (Daily life of original residents of Anson House)
• 12 March, 7:00–8:30 P.M.: Mr. Gregory Li (Challenges of restoring historic gardens)
• 19 March, 7:00–8:30 P.M.: Dr. Cornelia Payne (Discussions on book "The Transatlantic World of the Nineteenth Century", coauthored with Dr. Pragya Mehta. Dr. Payne has taught at the City University of Stoke-on-Trent in England for nearly 25 years).', N'Multiple Documents', NULL, 13);
    SET @dvId = SCOPE_IDENTITY();

    -- 186
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 186, N'Why did Dr. Mehta send the e-mail to Dr. Payne?', 'D', N'Dr. Mehta viết: "I am sorry for the late notice, but I will not be able to join you for the lecture" => Để gửi lời xin lỗi vì không thể tham gia.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'To cancel a vacation plan'),
    (@qId, 'B', N'To request lecture notes'),
    (@qId, 'C', N'To confirm a meeting'),
    (@qId, 'D', N'To offer an apology');

    -- 187
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 187, N'According to the second e-mail, what did Dr. Payne do?', 'A', N'Dr. Payne yêu cầu nhà xuất bản gửi 30 bản sách đến Anson House => Thu xếp vận chuyển sách (Arrange a delivery).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'Arrange a delivery'),
    (@qId, 'B', N'Give Mr. Halton a gift'),
    (@qId, 'C', N'Revise her presentation'),
    (@qId, 'D', N'Announce an address change');

    -- 188
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 188, N'What is indicated about Alphagamma Press?', 'C', N'Cornelia nhắc đến "My publisher, Alphagamma Press, will be sending 30 copies of my most recent work..." => Xuất bản quyển sách "The Transatlantic World of the Nineteenth Century".');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'It has headquarters in The Bahamas.'),
    (@qId, 'B', N'It regularly ships materials to Anson House.'),
    (@qId, 'C', N'It published The Transatlantic World of the Nineteenth Century.'),
    (@qId, 'D', N'It is paying Dr. Payne''s travel and accommodation expenses.');

    -- 189
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 189, N'Where were Dr. Mehta and Dr. Payne most likely colleagues?', 'C', N'Email ghi: "miss working with you at the City University" và trên web ghi "City University of Stoke-on-Trent" => Stoke-on-Trent.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'In Mumbai'),
    (@qId, 'B', N'In Freeport'),
    (@qId, 'C', N'In Stoke-on-Trent'),
    (@qId, 'D', N'In Charleston');

    -- 190
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 190, N'What is indicated about the Speaker Series in the Web page?', 'B', N'Trang web ghi: "Reservations are not required but are recommended" => Đặt chỗ trước là không bắt buộc (Reservations are optional).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'Discounts are unavailable.'),
    (@qId, 'B', N'Reservations are optional.'),
    (@qId, 'C', N'Events are held in the morning.'),
    (@qId, 'D', N'Refreshments are not included.');
END

-- Đoạn 191 - 195: Quảng cáo, E-mail và Thông cáo báo chí CRYN Group & Tayerson Ltd.
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 191)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 191-195 refer to the following advertisement, e-mail, and press release.',
    N'CRYN Group: We find the best employees for your company.
Posted: November 25
Position title and codes:
• Director of Operations, TL0015
• Marketing Director, TL0023
• Quality Control Director, TL0027
• Director of Category Management, TL0045

To apply: Send your resume to mdoro@cryngroup.ca.com with posting number 2098 in the subject line.
Company: Our client plans to chart an aggressive growth path in Latin America, where it plans to start operations next year. It is a well-established company widely known for marketing consumer-health products in North America, and more recently in Europe and Asia.
Qualifications: Candidates must have a formal business degree and a proven management record in at least one international setting. Experience with online sales and marketing preferred.

---

To: Sven Arvidson <sarvidson@barkent.de.com>
From: Maria Doro <mdoro@cryngroup.ca.com>
Re: Posting number 2098 | Date: December 10

Dear Mr. Arvidson,
Thank you for submitting your résumé. I''d like to schedule a preliminary telephone conversation with you as soon as possible to determine whether you would be a good choice for our client. I would particularly like to discuss whether you would be prepared to work at our client''s new facility overseas.
Let me know if you are available for a 30-minute phone call sometime between 10:00 A.M. and 2:00 P.M. EST on Monday or Tuesday of next week. Please respond to me by e-mail at your earliest convenience.
Maria Doro, CRYN Group

---

For immediate release: Contact Julie Dryden at 416-555-0103
Tayerson Ltd. Names New Director
Toronto, April 5—Tayerson Ltd. continues to staff its new international outpost, which opens one month from today. In this case, the lucky candidate is Sven Arvidson. "Category Management is a relatively new area—and one that I''m sure I''ll enjoy exploring and developing as director," Mr. Arvidson said. "As a major online marketer of nutritional supplements, Tayerson is poised to lead the way toward better living while becoming a more vibrant, more profitable corporation."
Mr. Arvidson has held several key management positions throughout his career, most recently at Barkent Pharmaceuticals in Germany. He was also a partner at MSZ Consulting Group, where he provided marketing guidance to leading consumer-product companies in Canada and China.', N'Multiple Documents', NULL, 14);
    SET @dvId = SCOPE_IDENTITY();

    -- 191
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 191, N'According to the advertisement, what qualification is not required of applicants?', 'D', N'Thông báo ghi "Experience with online sales and marketing preferred" (ưu tiên có chứ không bắt buộc).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'A degree in business'),
    (@qId, 'B', N'Previous employment in a managerial position'),
    (@qId, 'C', N'Experience working overseas'),
    (@qId, 'D', N'Online sales and marketing experience');

    -- 192
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 192, N'What most likely is the location of the position for which Mr. Arvidson applied?', 'A', N'Khách hàng mở rộng sang khu vực Mỹ Latinh: "chart an aggressive growth path in Latin America" => Vị trí ở Latin America.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'Latin America'),
    (@qId, 'B', N'North America'),
    (@qId, 'C', N'Europe'),
    (@qId, 'D', N'Asia');

    -- 193
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 193, N'What does Ms. Doro ask Mr. Arvidson to provide in his reply?', 'B', N'Maria hỏi: "Let me know if you are available for a 30-minute phone call..." => Thời gian rảnh để phỏng vấn (His availability for an interview).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'Information on his leadership skills'),
    (@qId, 'B', N'His availability for an interview'),
    (@qId, 'C', N'A current résumé'),
    (@qId, 'D', N'The names of two references');

    -- 194
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 194, N'What job code did Mr. Arvidson most likely reference in his application?', 'D', N'Sven Arvidson được bổ nhiệm làm Director of Category Management tương ứng với mã TL0045.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'TL0015'),
    (@qId, 'B', N'TL0023'),
    (@qId, 'C', N'TL0027'),
    (@qId, 'D', N'TL0045');

    -- 195
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 195, N'According to the press release, what does Tayerson Ltd. sell?', 'C', N'Thông cáo báo chí nêu: "marketer of nutritional supplements" => Thực phẩm chức năng / bổ sung dinh dưỡng (Nutritional supplements).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'Medical devices'),
    (@qId, 'B', N'Accounting software'),
    (@qId, 'C', N'Nutritional supplements'),
    (@qId, 'D', N'Exercise equipment');
END

-- Đoạn 196 - 200: Brochure, E-mail & Lịch Webinar FGJ Business Expert Series
IF NOT EXISTS (SELECT 1 FROM dbo.CauHoi WHERE PhanThiId = @Part7Id AND SoThuTuCau = 196)
BEGIN
    INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
    VALUES (@Part7Id, N'Questions 196-200 refer to the following brochure, e-mail, and schedule.',
    N'FGJ''s Business Expert Series: Prospect Data Purchasing (45-Minute Webinar, 11 May, 2:30 P.M.)
Every department in an organisation needs information to make business decisions. Marketing professionals in particular rely on accurate data about potential customers to be successful. In this Webinar, Briana Carrera, chief financial officer of Pile One Market Data, explains how to avoid the pitfalls of acquiring incomplete data and provides tips on what to ask your prospective data provider to ensure that your next batch of data leads to the results you want.

---

To: Sandra Lescure | From: Gino Stelleti | Date: 12 May | Subject: FGJ''s Webinar
Dear Sandra,
You had asked me to give you a report on the Webinar I attended yesterday about acquiring data. To be honest, even though the facilitator was clearly knowledgeable, she did not tell me anything I didn''t already know. I was hoping that she would show us the differences between the many types of databases out there, but she never touched on that topic. I am not so sure all these Webinars are useful; in the end, they always seem to be steering us to purchase from one particular company or another—in this case it was Pile One. Having said that, the new schedule just came out, and there is another Webinar coming up soon that I am hoping will provide the information I want about how to store and sort data. I have already signed up for it; I will keep you posted about what I learn.
Gino

---

Upcoming 45-Minute Webinars in FGJ''s Business Expert Series:
• Basics of Market Research: 1 June, 9:30 A.M. | Ed Quinones | €12.00
• Tips for Accelerating Sales: 12 June, 9:30 A.M. | Cameron Stone | €16.00
• What is Market Automation?: 5 July, 11:00 A.M. | Ed Quinones | €12.00
• Choosing the Right Database: 17 July, 2:00 P.M. | Selina Tucci | €12.00

The Business Expert Series is organised by Tuyet Nguyen. Please address any questions to her at tnguyen@fgj.org. To access Webinar content, attendance is required as Webinars are not recorded for later viewing.', N'Multiple Documents', NULL, 15);
    SET @dvId = SCOPE_IDENTITY();

    -- 196
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 196, N'According to the brochure, who would benefit most from the Prospect Data Purchasing Webinar?', 'B', N'Brochure ghi: "Marketing professionals in particular rely on accurate data..." => Quản lý tiếp thị (A marketing manager).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'A financial analyst'),
    (@qId, 'B', N'A marketing manager'),
    (@qId, 'C', N'A customer-service representative'),
    (@qId, 'D', N'An information-technology specialist');

    -- 197
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 197, N'What was Mr. Stelleti''s complaint about the Webinar?', 'B', N'Gino phàn nàn: "she did not tell me anything I didn''t already know" => Không học được điều gì mới.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'He did not like the format.'),
    (@qId, 'B', N'He did not learn anything new.'),
    (@qId, 'C', N'He had difficulty hearing everything.'),
    (@qId, 'D', N'He found the topic to be too complex.');

    -- 198
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 198, N'What does Mr. Stelleti suggest about Ms. Carrera?', 'D', N'Gino viết webinar dường như chèo kéo mua dữ liệu từ Pile One công ty của cô ấy => Cố gắng bán dịch vụ của công ty mình.');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'She recently joined a new company.'),
    (@qId, 'B', N'She has experience managing databases.'),
    (@qId, 'C', N'She had asked him to sign up for the Webinar.'),
    (@qId, 'D', N'She tried to sell her company''s services.');

    -- 199
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 199, N'When will Mr. Stelleti most likely attend another Webinar?', 'D', N'Gino muốn học về lưu trữ và sắp xếp dữ liệu (how to store and sort data) => Khóa "Choosing the Right Database" diễn ra ngày 17 tháng 7 (On July 17).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'On June 1'),
    (@qId, 'B', N'On June 12'),
    (@qId, 'C', N'On July 5'),
    (@qId, 'D', N'On July 17');

    -- 200
    INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
    VALUES (@Part7Id, @dvId, 200, N'According to the schedule, what do all of the Webinars have in common?', 'C', N'Tiêu đề ghi: "Upcoming 45-Minute Webinars" => Tất cả đều có cùng thời lượng 45 phút (They last the same amount of time).');
    SET @qId = SCOPE_IDENTITY();
    INSERT INTO dbo.DapAn VALUES 
    (@qId, 'A', N'They cost the same amount.'),
    (@qId, 'B', N'They are held in the morning.'),
    (@qId, 'C', N'They last the same amount of time.'),
    (@qId, 'D', N'They are recorded for future playback.');
END

PRINT N'Hoàn tất cập nhật 100 câu hỏi TOEIC Reading v09 vào database [de tanh] trên SQL Server thành công!';
GO
