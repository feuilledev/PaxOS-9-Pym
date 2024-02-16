#include "Button.hpp"
#include <iostream>

namespace gui::elements
{
    Button::Button(uint16_t x, uint16_t y, uint16_t width, uint16_t height)
    {
        this->m_x = x;
        this->m_y = y;
        this->m_width = width;
        this->m_height = height;

        this->m_label = nullptr;
        this->m_image = nullptr;

        this->m_borderColor = COLOR_DARK;
        this->m_borderSize = 2;
        this->m_backgroundColor = COLOR_WHITE;
        this->m_borderRadius = 17;

        m_theme = BUTTON_BLACK;
    }

    Button::~Button() = default;

    void Button::render()
    {
        m_surface->clear(COLOR_WHITE);
        m_surface->fillRoundRectWithBorder(0, 0,
            this->m_width, this->m_height, 
            this->m_borderRadius, this->m_borderSize, 
            this->m_backgroundColor, this->m_borderColor);
    }

    void Button::format()
    {
        uint16_t space = (m_image != nullptr && m_label != nullptr) ? 10 : 0;
        uint16_t w = space;

        if(m_image != nullptr)
            w += m_image->getWidth();
        if(m_label != nullptr)
            w += m_label->getTextWidth();

        if(m_image != nullptr)
            m_image->setX(getWidth()/2 - w/2);
        if(m_label != nullptr)
        {
            m_label->setX(getWidth()/2 - w/2 + space + ((m_image != nullptr) ? (m_image->getX() + m_image->getWidth()) : 0));
            m_label->setY(10);
            m_label->setWidth(m_label->getTextWidth());
            m_label->setFontSize(LABEL_SMALL);

            if(m_theme)
            {
                m_label->setTextColor(COLOR_DARK);
                m_label->setBackgroundColor(COLOR_WHITE);
            }else
            {
                m_label->setTextColor(COLOR_WHITE-1);
                m_label->setBackgroundColor(COLOR_DARK);
            }
            
            std::cout << "x: " << m_label->getX() << std::endl;
            std::cout << "y: " << m_label->getY() << std::endl;
            std::cout << "w: " << m_label->getWidth() << std::endl;
            std::cout << "h: " << m_label->getHeight() << std::endl;
        }

        if(m_theme)
        {
            this->setBackgroundColor(COLOR_WHITE);
        }else
        {
            this->setBackgroundColor(COLOR_DARK);
        }
    }

    void Button::setLabel(Label* label)
    {
        this->m_label = label;
        addChild(m_label);
    }

    void Button::setImage(Image* image)
    {
        this->m_image = image;
        addChild(m_image);
    }

    void Button::setTheme(bool value)
    {
        this->m_theme = value;
    }
}