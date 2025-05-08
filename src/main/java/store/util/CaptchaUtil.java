package store.util;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Random;

public class CaptchaUtil {
    // 图片宽度
    private static final int WIDTH = 90;
    // 图片高度
    private static final int HEIGHT = 35;
    // 验证码字符个数
    private static final int CODE_COUNT = 4;
    // 验证码干扰线数
    private static final int LINE_COUNT = 10;
    // 验证码范围，去掉了0和1(容易混淆的字符)
    private static final char[] CODE_SEQUENCE = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J',
            'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
            'X', 'Y', 'Z', '2', '3', '4', '5', '6', '7', '8', '9' };

    /**
     * 生成验证码并返回验证码文本
     */
    public static String generateCaptcha(OutputStream output) {
        // 定义图像buffer
        BufferedImage buffImg = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D gd = buffImg.createGraphics();

        // 创建一个随机数生成器类
        Random random = new Random();

        // 将图像填充为白色
        gd.setColor(Color.WHITE);
        gd.fillRect(0, 0, WIDTH, HEIGHT);

        // 创建字体，字体的大小应该根据图片的高度来定
        Font font = new Font("Fixedsys", Font.BOLD, 24);
        gd.setFont(font);

        // 画边框
        gd.setColor(Color.BLACK);
        gd.drawRect(0, 0, WIDTH - 1, HEIGHT - 1);

        // 随机产生干扰线，使图象中的认证码不易被其它程序探测到
        for (int i = 0; i < LINE_COUNT; i++) {
            int x = random.nextInt(WIDTH);
            int y = random.nextInt(HEIGHT);
            int xl = random.nextInt(12);
            int yl = random.nextInt(12);
            gd.setColor(new Color(random.nextInt(255), random.nextInt(255), random.nextInt(255)));
            gd.drawLine(x, y, x + xl, y + yl);
        }

        // 保存随机产生的验证码，以便用户登录后进行验证
        StringBuilder randomCode = new StringBuilder();

        // 随机产生验证码
        for (int i = 0; i < CODE_COUNT; i++) {
            // 得到随机产生的验证码数字
            String strRand = String.valueOf(CODE_SEQUENCE[random.nextInt(CODE_SEQUENCE.length)]);
            // 产生随机的颜色
            gd.setColor(new Color(random.nextInt(255), random.nextInt(255), random.nextInt(255)));
            // 在图片上画验证码
            gd.drawString(strRand, 15 * i + 10, 25);
            // 将产生的四个随机数组合在一起
            randomCode.append(strRand);
        }

        // 释放图形上下文
        gd.dispose();

        try {
            // 将图像输出到输出流中
            ImageIO.write(buffImg, "jpeg", output);
            output.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return randomCode.toString();
    }
}